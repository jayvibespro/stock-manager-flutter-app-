import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String id;
  String name;
  String description;
  String date;
  String admin;
  String lastMessage;
  List members;

  GroupModel({
    required this.lastMessage,
    required this.admin,
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.members,
  });

  factory GroupModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return GroupModel(
      id: doc.id,
      name: doc.data()!['name'],
      lastMessage: doc.data()!['last_message'],
      admin: doc.data()!['admin'],
      members: doc.data()!['members'],
      description: doc.data()!['description'],
      date: doc.data()!['created_at'],
    );
  }
}
