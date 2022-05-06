import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String id;
  String lastMessage;
  String receiverId;
  String senderId;
  String sender_name;
  String receiver_name;

  ConversationModel({
    required this.id,
    required this.senderId,
    required this.lastMessage,
    required this.receiverId,
    required this.sender_name,
    required this.receiver_name,
  });

  factory ConversationModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return ConversationModel(
      id: doc.id,
      senderId: doc.data()!['sender_id'],
      lastMessage: doc.data()!['last_message'],
      sender_name: doc.data()!['sender_name'],
      receiverId: doc.data()!['receiver_id'],
      receiver_name: doc.data()!['receiver_name'],
    );
  }
}
