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

class IncomePage extends StatefulWidget {
  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  var income = FirebaseFirestore.instance.collection('income');

  TextEditingController nameController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  Stream<List<ExpensesModel>> incomeStream() {
    try {
      return _db
          .collection("income")
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
        title: const Text('Income'),
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
          addIncomeBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<List<ExpensesModel>>(
        stream: incomeStream(),
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
                  ExpensesModel? incomeModel = snapshot.data![index];
                  return ListTile(
                    leading: Text('${incomeModel.date}'),
                    title: Text('${incomeModel.fullName}'),
                    subtitle: Text('${incomeModel.description}'),
                    trailing: Text('${incomeModel.amount}'),
                    onTap: () {
                      incomeDetailsBottomSheets(context, incomeModel);
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

  incomeDetailsBottomSheets(context, ExpensesModel? incomeDataModel) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.west,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            'Income info',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.black54,
                                ),
                                onPressed: () {
                                  editIncomeBottomSheets(
                                      context, incomeDataModel);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await income
                                      .doc(incomeDataModel?.id)
                                      .delete();
                                  Get.offAll(IncomePage());
                                },
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
                        trailing: Text('${incomeDataModel?.fullName}'),
                      ),
                      ListTile(
                        leading: const Text('Amount'),
                        trailing: Text('${incomeDataModel?.amount}'),
                      ),
                      ListTile(
                        leading: const Text('Description'),
                        trailing: Text('${incomeDataModel?.description}'),
                      ),
                      ListTile(
                        leading: const Text('Date'),
                        trailing: Text('${incomeDataModel?.date}'),
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

  addIncomeBottomSheets(context) {
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
                            await income.add({
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

  editIncomeBottomSheets(context, ExpensesModel? incomeDataModel) {
    setState(() {
      nameController.text = incomeDataModel!.fullName;
      amountController.text = incomeDataModel.amount;
      dateController.text = incomeDataModel.date;
      descriptionController.text = incomeDataModel.description;
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
                        child: Divider(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      IncomeEditField(
                        hint: "${incomeDataModel?.fullName}",
                        lable: "Full name",
                        controller: nameController,
                        keyboard: TextInputType.text,
                      ),
                      IncomeEditField(
                        lable: "Amount",
                        hint: "${incomeDataModel?.amount}",
                        controller: amountController,
                        keyboard: TextInputType.number,
                      ),
                      IncomeEditField(
                        lable: "Description",
                        hint: "${incomeDataModel?.description}",
                        controller: descriptionController,
                        keyboard: TextInputType.number,
                      ),
                      IncomeEditField(
                        lable: "Pick date",
                        hint: "${incomeDataModel?.date}",
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
                            await income.doc(incomeDataModel?.id).update({
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
                            Get.offAll(IncomePage());
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
          controller: controller,
          keyboardType: keyboard,
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

class IncomeEditField extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  String lable;
  String hint;

  IncomeEditField({
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
