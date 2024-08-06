import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/Login.dart';
import 'package:shoesapp/Data/User_reader.dart';
import 'package:intl/intl.dart'; 
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isEmailVerified = false;
  bool _isRegisterButtonDisabled = true;
  
  String _gender = 'Nam';
  Future<void> _register() async {
  if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
    Fluttertoast.showToast(msg: 'Mật khẩu không khớp. Vui lòng kiểm tra lại.');
    return;
  }

  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    final user = userCredential.user;
    if (user != null) {
      // Thêm người dùng vào Firestore
      final newUser = users(
        idUser: user.uid,
        email: user.email!,
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
        address: '', 
        phoneNumber: '', 
        gender: _gender, 
        dateOfBirth:  _dateOfBirthController.text.trim(), 
        imageUrl: '',
        status: false,
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      // Lưu dữ liệu người dùng vào SharedPreferences
      await SharedPrefsManager.saveUserId(user.uid);
      await SharedPrefsManager.saveGmail(user.email!);
      await SharedPrefsManager.saveUsername(_usernameController.text.trim());
      await SharedPrefsManager.saveImageUrl('');
      await SharedPrefsManager.savePassword(_passwordController.text.trim());
      await SharedPrefsManager.saveGender(_gender.trim());
      await SharedPrefsManager.saveBirthday(_dateOfBirthController.text.trim());

      Fluttertoast.showToast(msg: 'Đăng ký thành công. Vui lòng xác minh email của bạn.');
      await user.sendEmailVerification();
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Đăng ký thất bại: ${e.toString()}');
  }
}

  Future<void> _checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload(); // Làm mới trạng thái của người dùng
      if (user.emailVerified) {
        setState(() {
          _isEmailVerified = true;
          _isRegisterButtonDisabled = false;
        });
        Fluttertoast.showToast(msg: 'Email đã được xác minh.');
      } else {
        Fluttertoast.showToast(msg: 'Vui lòng xác minh email của bạn trước khi tiếp tục.');
      }
    }
  }

  void _activateAccount() {
    if (_isEmailVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
  Future<void> _selectDateOfBirth() async {
    final DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); 
  
    // Đổi định dạng ngày khi chọn ngày
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (selectedDate != null) {
      setState(() {
        
         _dateOfBirthController.text = formatter.format(selectedDate);
      
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                ),
                obscureText: true,
              ),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu', 
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Giới tính:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Nam',style: TextStyle(fontSize: 13),),
                          value: 'Nam',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Nữ',style: TextStyle(fontSize: 13),),
                          value: 'Nữ',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Khác',style: TextStyle(fontSize: 12),),
                          value: 'Khác',
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
              controller: _dateOfBirthController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày sinh',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectDateOfBirth,
                ),
              ),
            ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Đăng ký'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkEmailVerification,
                child: Text('Kiểm tra xác minh email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isEmailVerified ? _activateAccount : null,
                child: Text('Kích hoạt tài khoản'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}