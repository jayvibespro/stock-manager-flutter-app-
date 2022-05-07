import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  String id;
  int income;
  int expense;
  String userId;

  WalletModel({
    required this.userId,
    required this.id,
    required this.income,
    required this.expense,
  });

  factory WalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return WalletModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      income: doc.data()!['income'],
      expense: doc.data()!['expense'],
    );
  }
}
