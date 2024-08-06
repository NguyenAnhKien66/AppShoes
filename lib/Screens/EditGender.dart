import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class EditGenderAccount extends StatefulWidget {
  const EditGenderAccount({super.key});

  @override
  State<EditGenderAccount> createState() => _EditGenderAccountState();
}

class _EditGenderAccountState extends State<EditGenderAccount> {
  String _gender=SharedPrefsManager.getGender();
  String IdUser=SharedPrefsManager.getUserId();
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Giới Tính"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Nam',
                    style: TextStyle(fontSize: 13),
                  ),
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
                  title: Text(
                    'Nữ',
                    style: TextStyle(fontSize: 13),
                  ),
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
                  title: Text(
                    'Khác',
                    style: TextStyle(fontSize: 12),
                  ),
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
          ElevatedButton(onPressed: (){
           FirebaseFirestore.instance.collection('users').doc(IdUser).update({
        'gender': _gender,
      });
      SharedPrefsManager.saveGender(_gender);
      Navigator.pop(context, true);
          }, child: Text("Xác nhận"))
        ],
      ),
               
              
      );
    
  }
}