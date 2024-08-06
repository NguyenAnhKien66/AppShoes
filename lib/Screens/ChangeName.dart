import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController _controller = TextEditingController();
  String _currentName = '';
  bool _isNameValid = false;
  bool _isNameChanged = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUsername();
  }

  Future<void> _loadCurrentUsername() async {
    String storedUsername = SharedPrefsManager.getUsername();

    setState(() {
      _currentName = storedUsername;
      _controller.text = _currentName;
    });
  }

  void _validateName(String newName) {
    newName = newName.trim(); 
    setState(() {
      _isNameValid = newName.isNotEmpty && newName != _currentName;
      _isNameChanged = newName != _currentName;
    });
  }

  Future<void> _saveUsername(String newName) async {
    Future<void> storedUsername = SharedPrefsManager.saveUsername(newName);
    
    setState(() {
      _currentName = newName;
      _isNameChanged = false;
    });
  }

  void _handleSave() {
    if (_isNameValid) {
      _saveUsername(_controller.text);
      String idUser= SharedPrefsManager.getUserId();
      FirebaseFirestore.instance.collection('users').doc(idUser).update({'username': _controller.text});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nickname đã được cập nhật.')),
      );
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi tên'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              onChanged: _validateName,
              decoration: const InputDecoration(
                labelText: 'Tên mới',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _isNameValid
                      ? 'Tên hợp lệ'
                      : _isNameChanged
                          ? 'không hợp lệ'
                          : 'Tên trùng với tên hiện tại',
                  style: TextStyle(
                    color: _isNameValid ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isNameValid ? Icons.check_circle : Icons.cancel,
                  color: _isNameValid ? Colors.green : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isNameValid ? _handleSave : null,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
