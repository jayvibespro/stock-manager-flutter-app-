import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersModel {
  String id;
  String fullName;
  String phoneNumber;
  String location;
  String date;

  CustomersModel(
      {required this.id,
      required this.phoneNumber,
      required this.date,
      required this.fullName,
      required this.location});

  factory CustomersModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return CustomersModel(
        id: doc.id,
        phoneNumber: doc.data()!['phone_number'],
        date: doc.data()!['date'],
        fullName: doc.data()!['full_name'],
        location: doc.data()!['location']);
  }
}
