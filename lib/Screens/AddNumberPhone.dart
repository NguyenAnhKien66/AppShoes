import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPhoneNumberAccount extends StatefulWidget {
  @override
  _AddPhoneNumberAccountState createState() => _AddPhoneNumberAccountState();
}

class _AddPhoneNumberAccountState extends State<AddPhoneNumberAccount> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _sendCode() async {
    final phoneNumber = _phoneController.text.trim();

    // Đảm bảo số điện thoại theo định dạng E.164
    if (phoneNumber.isNotEmpty && phoneNumber.startsWith('+')) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Verification failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            // Handle code sent
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Handle timeout
          },
        );
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    } else {
      print('Invalid phone number format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCode,
              child: Text('Send verification code'),
            ),
          ],
        ),
      ),
    );
  }
}
