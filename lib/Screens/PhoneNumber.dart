import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class PhoneNumberAccount extends StatefulWidget {
  @override
  _PhoneNumberAccountState createState() => _PhoneNumberAccountState();
}

class _PhoneNumberAccountState extends State<PhoneNumberAccount> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;
String idUser = SharedPrefsManager.getUserId();
String phone = SharedPrefsManager.getPhone();
  // Hàm kiểm tra số điện thoại
  bool _validatePhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^0\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  // Hàm để xử lý khi thay đổi số điện thoại
  void _onPhoneNumberChanged(String phoneNumber) {
    setState(() {
      _isPhoneValid = _validatePhoneNumber(phoneNumber) && phoneNumber != phone;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Số điện thoại'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              
              decoration: InputDecoration(
                labelText: 'Phone Number',
                
                suffixIcon: _isPhoneValid
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: _onPhoneNumberChanged,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPhoneValid
                  ? () {
                      final phoneNumber = _phoneController.text.trim();
                      FirebaseFirestore.instance.collection('users').doc(idUser).update({
      'phoneNumber': phoneNumber,
    });
    SharedPrefsManager.savePhone(phoneNumber);
                      Navigator.pop(context,true);
                    }
                  : null,
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
