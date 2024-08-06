import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class EditBirthDayAccount extends StatefulWidget {
  const EditBirthDayAccount({super.key});

  @override
  State<EditBirthDayAccount> createState() => _EditBirthDayAccountState();
}

class _EditBirthDayAccountState extends State<EditBirthDayAccount> {
  final TextEditingController _dateOfBirthController = TextEditingController();
  String _birthDay = SharedPrefsManager.getBirthday();
  String idUser = SharedPrefsManager.getUserId();

  @override
  void initState() {
    super.initState();
    
    if (_birthDay.isNotEmpty) {
      _dateOfBirthController.text = _birthDay;
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime currentDate = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); 
  
    // Đổi định dạng ngày khi chọn ngày
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: formatter.parse(_birthDay),
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (selectedDate != null) {
      setState(() {
        
        _birthDay = formatter.format(selectedDate);
        _dateOfBirthController.text = _birthDay;
      });
    }
  }

  void _saveBirthDay() {
    FirebaseFirestore.instance.collection('users').doc(idUser).update({
      'dateOfBirth': _birthDay,
    });
    SharedPrefsManager.saveBirthday(_birthDay);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa Ngày Sinh"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: _saveBirthDay,
              child: Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}
