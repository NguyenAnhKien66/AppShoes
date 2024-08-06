import 'package:flutter/material.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart';
import 'package:shoesapp/Component/InformationAccount.dart';
import 'package:shoesapp/Component/OrderStatusAccount.dart';
import 'package:shoesapp/Component/SettingAcount.dart';
import 'package:shoesapp/Screens/FavoritesScreen.dart';
import 'package:shoesapp/Screens/HomeScreen.dart';
import 'package:shoesapp/Screens/NotificationScreen.dart';
import 'package:shoesapp/Screens/productCategoryScreen.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 4;
   @override
  void initState() {
    super.initState();

  }
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        break;
      case 1:
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductCategoryScreen(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
          ),
        );
        break;
      case 4:
       
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản cá nhân'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InformationAccount(),
            OrderStatusAccount(),
            SettingsAccount(),
          ],
        ),
        
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


