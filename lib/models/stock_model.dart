import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  String id;
  String userId;
  String fullName;
  String gunia;
  String deni;
  String nauli;
  String tumizi;
  String date;
  String changanya;
  String koboa;
  String kago;
  String kamba;

  StockModel({
    required this.id,
    required this.gunia,
    required this.nauli,
    required this.userId,
    required this.tumizi,
    required this.date,
    required this.fullName,
    required this.deni,
    required this.changanya,
    required this.kago,
    required this.kamba,
    required this.koboa,
  });

  factory StockModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return StockModel(
      id: doc.id,
      userId: doc.data()!['user_id'],
      gunia: doc.data()!['gunia'],
      nauli: doc.data()!['nauli'],
      tumizi: doc.data()!['tumizi'],
      date: doc.data()!['date'],
      fullName: doc.data()!['full_name'],
      deni: doc.data()!['deni'],
      changanya: doc.data()!['changanya'],
      kago: doc.data()!['kago'],
      kamba: doc.data()!['kamba'],
      koboa: doc.data()!['koboa'],
    );
  }
}
