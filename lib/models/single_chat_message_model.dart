import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatMessageModel {
  String id;
  String message;
  String date;
  String senderId;

  SingleChatMessageModel({
    required this.id,
    required this.senderId,
    required this.date,
    required this.message,
  });

  factory SingleChatMessageModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SingleChatMessageModel(
      id: doc.id,
      senderId: doc.data()!['sender_id'],
      date: doc.data()!['date'],
      message: doc.data()!['message'],
    );
  }
}
