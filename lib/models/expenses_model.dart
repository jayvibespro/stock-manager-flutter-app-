import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesModel {
  String id;
  String fullName;
  String amount;
  String date;
  String description;

  ExpensesModel({
    required this.id,
    required this.fullName,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory ExpensesModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return ExpensesModel(
      id: doc.id,
      fullName: doc.data()!['full_name'],
      amount: doc.data()!['amount'],
      description: doc.data()!['description'],
      date: doc.data()!['date'],
    );
  }
}
