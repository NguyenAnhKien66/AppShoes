import 'package:cloud_firestore/cloud_firestore.dart';

class users {
  final String idUser;
  final String email;
  final String password;
  final String username;
  final String address;
  final String phoneNumber;
  final String gender;
  final String dateOfBirth;
  final String imageUrl;
  final bool status;

  users({
    required this.idUser,
    required this.email,
    required this.password,
    required this.username,
    required this.address,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.status,
  });

  // Convert a User into a Map
  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'email': email,
      'password': password,
      'username': username,
      'address': address,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'imageUrl': imageUrl,
      'status': status,
    };
  }

  // Convert a Map into a User
  factory users.fromMap(Map<String, dynamic> map) {
    return users(
      idUser: map['idUser'],
      email: map['email'],
      password: map['password'],
      username: map['username'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'],
      imageUrl: map['imageUrl'],
      status: map['status'],
    );
  }
  
static Future<users?> loadUserById(String idUser) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(idUser)
          .get();

      if (docSnapshot.exists) {
        return users.fromMap(docSnapshot.data()!);
      } else {
        print('No user found with idUser: $idUser');
        return null;
      }
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }
}
