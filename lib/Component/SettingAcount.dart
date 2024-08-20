import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesapp/Screens/Login.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/ProfileUser.dart';

class SettingsAccount extends StatelessWidget {
  final Future<void> Function() onProfileEdit;

  SettingsAccount({required this.onProfileEdit});

  Future<void> _logout(BuildContext context) async {
    try {
      await SharedPrefsManager.clearPreferences();
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Chỉnh sửa hồ sơ'),
            onTap: () {
              onProfileEdit(); 
            },
          ),
          ListTile(
            title: Text('Cài đặt'),
            onTap: () {
              // Xử lý cài đặt tại đây
            },
          ),
          ListTile(
            title: Text('Yêu cầu hủy tài khoản'),
            onTap: () {
              // Xử lý yêu cầu hủy tài khoản tại đây
            },
          ),
          ListTile(
            title: Text('Đăng xuất'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}
