import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String id;
  String message;
  String receiverId;
  String senderId;
//  String time;

  ChatModel({
    required this.id,
    required this.message,
    required this.receiverId,
    required this.senderId,
//    required this.time,
  });

  factory ChatModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return ChatModel(
      id: doc.id,
      message: doc.data()!['message'],
      senderId: doc.data()!['receiver_id'],
      receiverId: doc.data()!['sender_id'],
//      time: doc.data()!['timestamp'],
    );
  }
}
