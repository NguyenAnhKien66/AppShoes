import 'package:flutter/material.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class InformationAccount extends StatefulWidget {
  
  @override
  State<InformationAccount> createState() => _InformationAccountState();
}

class _InformationAccountState extends State<InformationAccount> {
  
  @override
  Widget build(BuildContext context) {
     String Username = SharedPrefsManager.getUsername();
    String email=SharedPrefsManager.getGmail();
    String img=SharedPrefsManager.getImageUrl();
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: img.isNotEmpty? NetworkImage(img):AssetImage('assets/account.png'),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Username,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(email), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}