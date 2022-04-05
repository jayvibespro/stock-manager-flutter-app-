import 'package:cloud_firestore/cloud_firestore.dart';

class AdvanceModel {
  String id;
  String userId;
  String seller;
  String buyer;
  String amountPaid;
  String price;
  String status;
  String date;

  AdvanceModel({
    required this.id,
    required this.userId,
    required this.buyer,
    required this.price,
    required this.status,
    required this.date,
    required this.seller,
    required this.amountPaid,
  });

  factory AdvanceModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return AdvanceModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      buyer: doc.data()!['buyer'],
      price: doc.data()!['price'],
      status: doc.data()!['status'],
      date: doc.data()!['date'],
      seller: doc.data()!['seller'],
      amountPaid: doc.data()!['amount paid'],
    );
  }
}
