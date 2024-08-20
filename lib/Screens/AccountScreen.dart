import 'package:flutter/material.dart';

import 'package:shoesapp/Component/InformationAccount.dart';
import 'package:shoesapp/Component/OrderStatusAccount.dart';
import 'package:shoesapp/Component/SettingAcount.dart';
import 'package:shoesapp/Screens/ProfileUser.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  
   @override
  void initState() {
    super.initState();
    print("load laintrang");
  }
  Future<void> _navigateToUserProfile() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UserProfilePage(),
    ),
  );

 
  if (result == true) {
    
    setState(() {
      
    });
  }
}
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            InformationAccount(),
            OrderStatusAccount(),
            SettingsAccount(onProfileEdit: _navigateToUserProfile),
          ],
        ),
        
      ),
      
    );
  }
}


