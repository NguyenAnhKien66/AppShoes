import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          
          UserAccountsDrawerHeader(
            accountName: Text("Tên tài khoản"),
            accountEmail: Text("email@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text("A"),
            ),
          ),
          
          ListTile(
            leading: Icon(Icons.male),
            title: Text("Nam"),
            onTap: () {
             
              Navigator.of(context).pop(); 
            },
          ),
          ListTile(
            leading: Icon(Icons.female),
            title: Text("Nữ"),
            onTap: () {
              
              Navigator.of(context).pop(); 
             
            },
          ),
          ListTile(
            leading: Icon(Icons.child_care),
            title: Text("Bé trai"),
            onTap: () {
             
              Navigator.of(context).pop(); 
              
            },
          ),
          ListTile(
            leading: Icon(Icons.girl),
            title: Text("Bé gái"),
            onTap: () {
              // Navigate to Bé gái products
              Navigator.of(context).pop(); // Close the drawer
              // Add your navigation logic here
            },
          ),
          Divider(), // Divider between product categories and settings
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Cài đặt"),
            onTap: () {
              // Navigate to settings
              Navigator.of(context).pop(); // Close the drawer
              // Add your navigation logic here
            },
          ),
        ],
      ),
    );
  }
}
