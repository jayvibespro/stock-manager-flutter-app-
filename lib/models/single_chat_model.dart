import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatModel {
  String id;
  String receiverName;
  String receiverImage;
  String receiverEmail;
  String lastDate;
  String lastMessage;
  List members;

  SingleChatModel({
    required this.receiverEmail,
    required this.receiverName,
    required this.receiverImage,
    required this.lastDate,
    required this.lastMessage,
    required this.members,
    required this.id,
  });

  factory SingleChatModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return SingleChatModel(
      receiverEmail: doc.data()!['receiver_email'],
      receiverName: doc.data()!['receiver_name'],
      receiverImage: doc.data()!['receiver_image'],
      lastDate: doc.data()!['last_date'],
      lastMessage: doc.data()!['last_message'],
      members: doc.data()!['members'],
      id: doc.id,
    );
  }
}
