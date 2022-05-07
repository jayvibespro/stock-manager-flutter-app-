import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  String? id;
  String? userId;
  int? income;
  int? expense;

  WalletService({
    this.userId,
    this.id,
    this.expense,
    this.income,
  });

  createWallet() async {
    var balance = await FirebaseFirestore.instance.collection('wallet').add({
      'income': income,
      'expense': expense,
      'user_id': userId,
    });
  }

  updateIncome() async {
    var balance =
        await FirebaseFirestore.instance.collection('wallet').doc(id).update({
      'income': income,
    });
  }

  updateExpense() async {
    var balance =
        await FirebaseFirestore.instance.collection('wallet').doc(id).update({
      'expense': expense,
    });
  }
}
