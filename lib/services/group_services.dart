import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  String? id;
  String? name;
  String? description;
  String? admin;
  String? date;
  String? lastMessage;
  List? members;

  GroupService({
    this.id,
    this.lastMessage,
    this.name,
    this.description,
    this.date,
    this.admin,
    this.members,
  });

  createGroup() async {
    var group = await FirebaseFirestore.instance.collection('groups').add({
      'name': name,
      'description': description,
      'members': members,
      'created_at': date,
      'admin': admin,
      'last_message': lastMessage,
    });
  }

  updateLastMessage() async {
    var group =
        await FirebaseFirestore.instance.collection('groups').doc(id).update({
      'last_message': lastMessage,
    });
  }
}
