import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/Data/Address_dart.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Component/AddAddress.dart';
import 'package:shoesapp/Screens/ProfileUser.dart';

class ChangeAddress extends StatefulWidget {
  @override
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  late String userId;
  late List<Address> addresses;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = SharedPrefsManager.getUserId();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();

      addresses = querySnapshot.docs.map((doc) {
        final addressData = doc.data();
        final addressId = doc.id;
        return Address.fromMap(addressData, addressId);
      }).toList();
    } catch (e) {
      print('Error loading addresses: $e');
      addresses = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _navigateToAddAddress({Address? address}) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddAddress(address: address),
    ),
  );

  if (result == true) {
    _loadAddresses();
  }
}
 Future<void> _navigateToUserProfile() async {
   Navigator.pop(context,true);
  
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Change Address')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Address'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddAddress(),
          ),
        ],
        leading: IconButton(onPressed: _navigateToUserProfile, icon: Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
      
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          return ListTile(
            title: Text(address.houseAddress+" "+address.ward+""+address.district+" "+address.province),
            subtitle: address.isDefault ? Text('Mặc định', style: TextStyle(color: Colors.blueGrey)) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToAddAddress(address: address),
                ),
                
              ],
            ),
            onTap: () => _navigateToAddAddress(address: address),
          );
        },
      ),
    );
  }
}
