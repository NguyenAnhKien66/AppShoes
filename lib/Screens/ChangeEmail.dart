import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmailAccount extends StatefulWidget {
  const ChangeEmailAccount({super.key});

  @override
  _ChangeEmailAccountState createState() => _ChangeEmailAccountState();
}

class _ChangeEmailAccountState extends State<ChangeEmailAccount> {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _changeEmail() async {
  setState(() {
    _errorMessage = null;
    _isLoading = true;
  });

  final currentEmail = _currentEmailController.text.trim();
  final newEmail = _newEmailController.text.trim();
  final password = _passwordController.text.trim();

  try {
    final user = _auth.currentUser;

    if (user != null) {
      // Xác thực mật khẩu
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );

      // Reauthenticate with the credential
      await user.reauthenticateWithCredential(credential);

      // Gửi email xác thực đến email mới
      await user.updateEmail(newEmail);
      await user.sendEmailVerification();

      // Thông báo thành công
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thành công'),
          content: Text('Email đã được cập nhật. Vui lòng kiểm tra email xác thực.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Không có người dùng đang đăng nhập.';
      });
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = e.message;
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentEmailController,
              decoration: InputDecoration(labelText: 'Email hiện tại'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _newEmailController,
              decoration: InputDecoration(labelText: 'Email mới'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _changeEmail,
                child: Text('Cập nhật email'),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
