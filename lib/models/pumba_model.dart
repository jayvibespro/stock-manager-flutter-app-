import 'package:cloud_firestore/cloud_firestore.dart';

class PumbaModel {
  String userId;
  String id;
  String gunia;
  String date;

  PumbaModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.gunia,
  });

  factory PumbaModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return PumbaModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      date: doc.data()!['date'],
      gunia: doc.data()!['gunia'],
    );
  }
}
