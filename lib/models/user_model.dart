import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String password;
  String userName;
  String phoneNumber;
  String gender;
  String location;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.userName,
    required this.phoneNumber,
    required this.gender,
    required this.location,
  });

  factory UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return UserModel(
      id: doc.id,
      email: doc.data()!['email'],
      password: doc.data()!['password'],
      userName: doc.data()!['user_name'],
      phoneNumber: doc.data()!['phone_number'],
      gender: doc.data()!['gender'],
      location: doc.data()!['location'],
    );
  }
}
