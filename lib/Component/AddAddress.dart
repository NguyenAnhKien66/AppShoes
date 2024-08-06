import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/Data/Address_dart.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class AddAddress extends StatefulWidget {
  final Address? address; 
  const AddAddress({Key? key, this.address}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late TextEditingController _houseAddressController;
  late TextEditingController _wardController;
  late TextEditingController _districtController;
  late String _selectedProvince;
  bool _isDefault = false;
  final List<String> _provinces = ['Tp. Hồ Chí Minh', 'Bình Dương', 'Vũng tàu']; 

  @override
  void initState() {
    super.initState();

    _houseAddressController = TextEditingController(text: widget.address?.houseAddress);
    _wardController = TextEditingController(text: widget.address?.ward);
    _districtController = TextEditingController(text: widget.address?.district);

    // Ensure _selectedProvince is set to a valid value
    if (widget.address?.province != null && _provinces.contains(widget.address?.province)) {
      _selectedProvince = widget.address!.province;
    } else {
      _selectedProvince = _provinces.isNotEmpty ? _provinces[0] : '';
    }

    _isDefault = widget.address?.isDefault ?? false;
  }

  Future<void> _saveAddress() async {
  final houseAddress = _houseAddressController.text;
  final ward = _wardController.text;
  final district = _districtController.text;
  final province = _selectedProvince;
  String addressfull="";
  if (houseAddress.isEmpty || ward.isEmpty || district.isEmpty || province.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please fill in all fields'),
    ));
    return;
  }

  try {
    final userId = await SharedPrefsManager.getUserId();
    final addressData = {
      'houseAddress': houseAddress,
      'ward': ward,
      'district': district,
      'province': province,
      'isDefault': _isDefault,
    };

    final addressesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses');

    DocumentReference newAddressRef;
    if (widget.address == null) {
      newAddressRef = await addressesCollection.add(addressData);
    } else {
      // Update existing address
      newAddressRef = addressesCollection.doc(widget.address!.id);
      await newAddressRef.update(addressData);
    }

    // Nếu địa chỉ mới được đặt làm mặc định, cập nhật tất cả các địa chỉ khác và cập nhật tài liệu người dùng
    if (_isDefault) {
      final addressesSnapshot = await addressesCollection.get();
      for (var doc in addressesSnapshot.docs) {
        if (doc.id != newAddressRef.id) {
          await doc.reference.update({'isDefault': false});
        }
      }
      addressfull=houseAddress+" "+ward+""+district+" "+province;
      // Cập nhật trường `address` của người dùng với địa chỉ mới
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'address':addressfull
      });
      SharedPrefsManager.saveAddress(addressfull);
    }

    Navigator.pop(context, true);
  } catch (e) {
    print('Error saving address: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error saving address'),
    ));
  }
}


  Future<void> _deleteAddress() async {
  if (widget.address?.id == null || widget.address!.id.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Invalid address ID'),
    ));
    return;
  }

  try {
    final userId = await SharedPrefsManager.getUserId();
    final addressCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses');

    // Kiểm tra xem địa chỉ đang xóa có phải là địa chỉ mặc định không
    final addressSnapshot = await addressCollection.doc(widget.address!.id).get();
    final isDefault = addressSnapshot.data()?['isDefault'] ?? false;

    await addressCollection.doc(widget.address!.id).delete();

    if (isDefault) {
      // Nếu địa chỉ đang xóa là mặc định, cập nhật trường address của người dùng thành rỗng
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'address': '',
      });
      SharedPrefsManager.saveAddress('');
    }

    Navigator.pop(context, true);
  } catch (e) {
    print('Error deleting address: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error deleting address'),
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        actions: widget.address != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteAddress,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _houseAddressController,
                decoration: InputDecoration(labelText: 'Số nhà'),
              ),
              TextField(
                controller: _wardController,
                decoration: InputDecoration(labelText: 'Phường/Xã'),
              ),
              TextField(
                controller: _districtController,
                decoration: InputDecoration(labelText: 'Quận/Huyện'),
              ),
              DropdownButton<String>(
                value: _selectedProvince,
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value!;
                  });
                },
                items: _provinces.map((province) {
                  return DropdownMenuItem(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                hint: Text('Chọn tỉnh/thành phố'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Đặt làm mặc định'),
                  Switch(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _saveAddress,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
