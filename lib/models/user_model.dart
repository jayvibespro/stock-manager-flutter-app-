import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String email;
  String name;
  String phoneNumber;
  String gender;
  String avatarUrl;
  String location;
  String userId;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.gender,
    required this.location,
    required this.userId,
  });

  factory UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return UserModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      email: doc.data()!['email'],
      name: doc.data()!['name'],
      avatarUrl: doc.data()!['avatar_url'],
      phoneNumber: doc.data()!['phone_number'],
      gender: doc.data()!['gender'],
      location: doc.data()!['location'],
    );
  }
}
