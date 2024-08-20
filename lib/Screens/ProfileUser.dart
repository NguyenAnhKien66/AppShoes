import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoesapp/Data/User_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/AccountScreen.dart';
import 'package:shoesapp/Screens/ChangeAddress.dart';
import 'package:shoesapp/Screens/ChangeEmail.dart';
import 'package:shoesapp/Screens/ChangeName.dart';
import 'package:shoesapp/Screens/ChangePassword.dart';
import 'package:shoesapp/Screens/EditBirthDay.dart';
import 'package:shoesapp/Screens/EditGender.dart';
import 'package:shoesapp/Screens/PhoneNumber.dart';

class UserProfilePage extends StatefulWidget {
  

  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  users? currentUser;
  bool isLoading = true;
  String userId=SharedPrefsManager.getUserId();
  String pass=SharedPrefsManager.getPassword();
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }
  String maskedValue(String password) {
  if (password.length <= 2) {
    return password;
  }
  String visiblePart = password.substring(password.length - 2);
  String maskedPart = '*' * (password.length - 2);
  return maskedPart + visiblePart;
}

  Future<void> _loadUserInfo() async {
    final user = await users.loadUserById(userId);
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }
  Future<void> _navigateToChangeName() async {
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
  Future<void> _navigateToChangePassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePasswordAccount(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
  Future<void> _navigateToChangePhone() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneNumberAccount(),
      ),
    );

    if (result == true) {
      _loadUserInfo(); 
    }
  }
 
  
Future<void> _updateProfilePicture() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    File file = File(image.path);
    String filePath = 'profile_pictures/${userId}_${DateTime.now().millisecondsSinceEpoch}.png';
    
    try {
      print("Bắt đầu tải lên ảnh");
      await FirebaseStorage.instance.ref(filePath).putFile(file);
      print("Tải lên ảnh thành công");

      print("Lấy URL của ảnh");
      String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      print("URL của ảnh: $downloadUrl");

      print("Cập nhật URL vào Firestore");
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'imageUrl': downloadUrl,
      });

      print("Cập nhật UI");
      setState(() {
        currentUser!.imageUrl = downloadUrl;
        SharedPrefsManager.saveImageUrl(downloadUrl);
      });

      print('Upload successful, URL: $downloadUrl');
    } catch (e) {
      print('Upload failed: ${e.toString()}');
    }
  } else {
    print("Không có ảnh nào được chọn");
  }
}



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Thông tin cá nhân'),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
         Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => AccountScreen(),
  ),
);
        }, icon: Icon(Icons.arrow_back)),),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Thông tin cá nhân'),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
         Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => AccountScreen(),
  ),
);
        }, icon: Icon(Icons.arrow_back)),
        ),
        
        body: Center(child: Text('Không tìm thấy thông tin người dùng')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Thông tin cá nhân'),
automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          print("ve");
         Navigator.pop(context,true);
        }, icon: Icon(Icons.arrow_back)),
      ),
        
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
  onTap: _updateProfilePicture,
  child: Container(
    width: 300, 
    height: 300,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(
          currentUser!.imageUrl.isNotEmpty ? currentUser!.imageUrl : 'assets/account.png'
        ),
        fit: BoxFit.cover,  
      ),
    ),
  ),
),
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
            subtitle: Text(maskedValue(pass)),
            onTap:_navigateToChangePassword
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
            subtitle: currentUser!.phoneNumber.isEmpty?Text("Chưa xác định"):Text(maskedValue(currentUser!.phoneNumber)),
            onTap: _navigateToChangePhone
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
