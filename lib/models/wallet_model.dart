import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  String id;
  String userId;
  String balance;
  String income;
  String expense;

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.income,
    required this.expense,
  });

  factory WalletModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return WalletModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      balance: doc.data()!['balance'],
      income: doc.data()!['income'],
      expense: doc.data()!['expense'],
    );
  }
}
