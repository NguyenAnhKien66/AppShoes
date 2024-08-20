import 'package:flutter/material.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class UserProfileNotifier extends ChangeNotifier {
  String _username = SharedPrefsManager.getUsername();
  String _email = SharedPrefsManager.getGmail();
  String _img = SharedPrefsManager.getImageUrl();

  String get username => _username;
  String get email => _email;
  String get img => _img;

  void updateUserProfile(String username, String email, String img) {
    _username = username;
    _email = email;
    _img = img;
    notifyListeners();
  }
}
