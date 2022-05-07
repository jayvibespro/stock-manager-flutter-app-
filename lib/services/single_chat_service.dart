import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChatService {
  String? id;
  String? receiverName;
  String? receiverImage;
  String? receiverEmail;
  String? senderId;
  String? lastDate;
  String? message;
  String? date;
  String? lastMessage;
  List? members;

  SingleChatService({
    this.message,
    this.id,
    this.receiverEmail,
    this.lastMessage,
    this.senderId,
    this.lastDate,
    this.date,
    this.members,
    this.receiverImage,
    this.receiverName,
  });

  createChat() async {
    await FirebaseFirestore.instance.collection('single_chat').add({
      'members': members,
      'last_message': lastMessage,
      'last_date': lastDate,
      'receiver_email': receiverEmail,
      'receiver_image': receiverImage,
      'receiver_name': receiverName,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('single_chat')
          .doc(value.id)
          .collection('messages')
          .add({
        'message': message,
        'sender_id': senderId,
        'date': date,
      });
    });
  }

  updateChat() async {
    await FirebaseFirestore.instance.collection('single_chat').doc(id).update({
      'last_message': lastMessage,
      'last_date': lastDate,
      'receiver_email': receiverEmail,
      'receiver_image': receiverImage,
      'receiver_name': receiverName,
    });
  }

  sendMessage() async {
    await FirebaseFirestore.instance
        .collection('single_chat')
        .doc(id)
        .collection('messages')
        .add({
      'message': message,
      'sender_id': senderId,
      'date': date,
    });
  }
}
