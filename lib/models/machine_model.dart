import 'package:cloud_firestore/cloud_firestore.dart';

class MachineModel {
  String id;
  String userId;
  String fullName;
  String kg;
  String date;
  bool isDone;

  MachineModel({
    required this.id,
    required this.kg,
    required this.userId,
    required this.date,
    required this.isDone,
    required this.fullName,
  });

  factory MachineModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return MachineModel(
      userId: doc.data()!['user_id'],
      isDone: doc.data()!['isDone'],
      id: doc.id,
      kg: doc.data()!['kg'],
      date: doc.data()!['date'],
      fullName: doc.data()!['full_name'],
    );
  }
}
