import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/models/income_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';

import '../../system_app_pages/login_page.dart';
import '../../system_app_pages/search_page.dart';

class ExpensesPage extends StatefulWidget {
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  var expenses = FirebaseFirestore.instance.collection('expenses');

  TextEditingController nameController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<ExpensesModel>> expensesStream() {
    try {
      return _db
          .collection("expenses")
          .where("user_id", isEqualTo: auth.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<ExpensesModel> dataFromFireStore = <ExpensesModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(ExpensesModel.fromDocumentSnapshot(doc: doc));
        }
        print(dataFromFireStore);
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Expenses'),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Icon(Icons.search),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            child: const Icon(Icons.logout),
            onTap: () {
              AuthServices(email: '', password: '').logoutUser();
              Get.offAll(() => LoginPage());
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addExpenseBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<List<ExpensesModel>>(
        stream: expensesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Data Loaded...'),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An Error Occured...'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ExpensesModel? expensesModel = snapshot.data![index];
                  return ListTile(
                    leading: Text('${expensesModel.date}'),
                    title: Text('${expensesModel.fullName}'),
                    subtitle: Text('${expensesModel.description}'),
                    trailing: Text('${expensesModel.amount}'),
                    onTap: () {
                      expensesDetailsBottomSheets(context, expensesModel);
                    },
                  );
                });
          } else {
            return const Center(
              child: Text('An Error Occured...'),
            );
          }
        },
      ),
    );
  }

  expensesDetailsBottomSheets(context, ExpensesModel? expensesDataModel) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.west,
                            ),
                          ),
                          const Text(
                            'Expense info',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  editExpenseBottomSheets(
                                      context, expensesDataModel);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await expenses
                                      .doc(expensesDataModel?.id)
                                      .delete();
                                  Get.offAll(ExpensesPage());
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        leading: const Text('Full name'),
                        trailing: Text('${expensesDataModel?.fullName}'),
                      ),
                      ListTile(
                        leading: const Text('Amount'),
                        trailing: Text('${expensesDataModel?.amount}'),
                      ),
                      ListTile(
                        leading: const Text('Description'),
                        trailing: Text('${expensesDataModel?.description}'),
                      ),
                      ListTile(
                        leading: const Text('Date'),
                        trailing: Text('${expensesDataModel?.date}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }

  addExpenseBottomSheets(context) {
    var timestamp = FieldValue.serverTimestamp();

    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(currentDate);

    setState(() {
      nameController.clear();
      amountController.clear();
      descriptionController.clear();
    });

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.west,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'New income record',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      NewInputField(
                        lable: "Full name",
                        keyboard: TextInputType.text,
                        controller: nameController,
                      ),
                      NewInputField(
                        lable: "Amount",
                        keyboard: TextInputType.number,
                        controller: amountController,
                      ),
                      NewInputField(
                        lable: "Description",
                        keyboard: TextInputType.text,
                        controller: descriptionController,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
                        child: GestureDetector(
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  blurRadius: 10.0,
                                  offset: Offset(2, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            await expenses.add({
                              'full_name': nameController.text,
                              'amount': amountController.text,
                              'description': descriptionController.text,
                              'date': formattedDate,
                              'user_id': auth.currentUser?.uid,
                              'timestamp': timestamp,
                            });
                            setState(() {
                              nameController.clear();
                              amountController.clear();
                              descriptionController.clear();
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }

  editExpenseBottomSheets(context, ExpensesModel? expenseDataModel) {
    setState(() {
      nameController.text = expenseDataModel!.fullName;
      amountController.text = expenseDataModel.amount;
      dateController.text = expenseDataModel.date;
      descriptionController.text = expenseDataModel.description;
    });

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Icon(
                            Icons.west,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Edit record',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ExpenseEditField(
                        hint: "${expenseDataModel?.fullName}",
                        lable: "Full name",
                        controller: nameController,
                        keyboard: TextInputType.text,
                      ),
                      ExpenseEditField(
                        lable: "Amount",
                        hint: "${expenseDataModel?.amount}",
                        controller: amountController,
                        keyboard: TextInputType.number,
                      ),
                      ExpenseEditField(
                        lable: "Description",
                        hint: "${expenseDataModel?.description}",
                        controller: descriptionController,
                        keyboard: TextInputType.number,
                      ),
                      ExpenseEditField(
                        lable: "Date",
                        hint: "${expenseDataModel?.date}",
                        controller: dateController,
                        keyboard: TextInputType.datetime,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
                        child: GestureDetector(
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  blurRadius: 10.0,
                                  offset: Offset(2, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Save changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            await expenses.doc(expenseDataModel?.id).update({
                              'full_name': nameController.text,
                              'amount': amountController.text,
                              'description': descriptionController.text,
                              'date': dateController.text,
                            });
                            setState(() {
                              nameController.clear();
                              amountController.clear();
                              descriptionController.clear();
                              dateController.clear();
                            });
                            Get.offAll(ExpensesPage());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
//  await Future.delayed(Duration(seconds: 5));
//  Navigator.pop(context);
  }
}

class NewInputField extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  String lable;

  NewInputField({
    Key? key,
    required this.lable,
    required this.keyboard,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        child: TextField(
          keyboardType: keyboard,
          controller: controller,
          decoration: InputDecoration(
            hintText: lable,
            labelText: lable,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(143, 148, 251, 0.5),
              blurRadius: 5.0,
              offset: Offset(2, 6),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseEditField extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  String lable;
  String hint;

  ExpenseEditField({
    Key? key,
    required this.lable,
    required this.hint,
    required this.controller,
    required this.keyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            labelText: lable,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(143, 148, 251, 0.5),
              blurRadius: 5.0,
              offset: Offset(2, 6),
            ),
          ],
        ),
      ),
    );
  }
}
