import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessageModel {
  String senderId;
  String message;
  String id;
  String date;

  GroupMessageModel({
    required this.senderId,
    required this.message,
    required this.id,
    required this.date,
  });

  factory GroupMessageModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return GroupMessageModel(
      id: doc.id,
      senderId: doc.data()!['sender_id'],
      message: doc.data()!['message'],
      date: doc.data()!['created_at'],
    );
  }
}
