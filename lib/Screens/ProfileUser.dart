import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoesapp/Data/User_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/ChangeAddress.dart';
import 'package:shoesapp/Screens/ChangeEmail.dart';
import 'package:shoesapp/Screens/ChangeName.dart';
import 'package:shoesapp/Screens/EditBirthDay.dart';
import 'package:shoesapp/Screens/EditGender.dart';

class UserProfilePage extends StatefulWidget {
  

  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  users? currentUser;
  bool isLoading = true;
  String userId=SharedPrefsManager.getUserId();
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await users.loadUserById(userId);
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }
  Future<void> _navigateToChangeName() async {
    // Navigate to ChangeName page and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeName(),
      ),
    );

    // If result is true, reload user info
    if (result == true) {
      _loadUserInfo();
    }
  }
  Future<void> _navigateToChangeAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeAddress(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
  Future<void> _navigateToEditGender() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGenderAccount(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
  Future<void> _navigateToEditBirthDay() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthDayAccount(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
  Future<void> _navigateToChangeEmail() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeEmailAccount(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
 
  Future<void> _updateProfilePicture() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   // Update image URL in the database
    //   // Implement the logic to upload the image and update `imageUrl`
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Thông tin cá nhân')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Thông tin cá nhân')),
        body: Center(child: Text('Không tìm thấy thông tin người dùng')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Thông tin cá nhân')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Avatar
          // GestureDetector(
          //   onTap: _updateProfilePicture,
          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage: NetworkImage(currentUser!.imageUrl),
          //   ),
          // ),
          SizedBox(height: 16.0),
          // Nickname
          ListTile(
            title: Text('Nickname'),
            subtitle: Text(currentUser!.username),
            onTap: () {
             _navigateToChangeName();
        
            },
          ),
          // Email
          ListTile(
            title: Text('Email'),
            subtitle: Text(currentUser!.email),
            onTap:_navigateToChangeEmail
          ),
          // Password
          ListTile(
            title: const Text('Password'),
            subtitle: Text('******'),
            onTap: () {
              // Navigate to edit password page
            },
          ),
          // Address
          ListTile(
            title: Text('Address'),
            subtitle:  currentUser!.address.isEmpty?Text("Chưa xác định"):Text(currentUser!.address),
            onTap: () {
              _navigateToChangeAddress();
            },
          ),
          // Phone Number
          ListTile(
            title: Text('Phone Number'),
            subtitle: currentUser!.phoneNumber.isEmpty?Text("Chưa xác định"):Text(currentUser!.phoneNumber),
            onTap: () {
              
            },
          ),
          // Gender
          ListTile(
            title: Text('Gender'),
            subtitle: currentUser!.gender.isEmpty?Text("Chưa xác định"):Text(currentUser!.gender),
            onTap:  _navigateToEditGender
          ),
          // Date of Birth
          ListTile(
            title: Text('Date of Birth'),
            subtitle:  currentUser!.dateOfBirth.isEmpty?Text("Chưa xác định"):Text(currentUser!.dateOfBirth),
            onTap:  _navigateToEditBirthDay
          ),
        ],
      ),
    );
  }
}
