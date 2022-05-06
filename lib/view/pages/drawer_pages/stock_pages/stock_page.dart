import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/models/stock_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';
import 'package:stocksmanager/view/pages/drawer_pages/stock_pages/stock_details_page.dart';

import '../../system_app_pages/login_page.dart';
import '../../system_app_pages/search_page.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  var stock = FirebaseFirestore.instance.collection('stock');

  TextEditingController nameController = TextEditingController();
  TextEditingController guniaController = TextEditingController();
  TextEditingController nauliController = TextEditingController();
  TextEditingController changanyaController = TextEditingController();
  TextEditingController koboaController = TextEditingController();
  TextEditingController kagoController = TextEditingController();
  TextEditingController tumiziController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController kambaController = TextEditingController();
  TextEditingController deniController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<StockModel>> incomeStream() {
    try {
      return _db
          .collection("stock")
          .where("user_id", isEqualTo: auth.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<StockModel> dataFromFireStore = <StockModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(StockModel.fromDocumentSnapshot(doc: doc));
        }
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
    guniaController.dispose();
    nauliController.dispose();
    changanyaController.dispose();
    koboaController.dispose();
    dateController.dispose();
    kagoController.dispose();
    tumiziController.dispose();
    kambaController.dispose();
    deniController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Stocks'),
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
          addStockBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<List<StockModel>>(
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
                  StockModel stockModel = snapshot.data![index];
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFECF0F1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${stockModel.fullName}'),
                            Text('${stockModel.date}'),
                            Text('${stockModel.gunia}'),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StockDetailsPage(
                                            stockData: stockModel)));
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StockDetailsPage(stockData: stockModel)));
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

  addStockBottomSheets(context) {
    var timestamp = FieldValue.serverTimestamp();

    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(currentDate);

    setState(() {
      nameController.clear();
      guniaController.clear();
      kagoController.clear();
      kambaController.clear();
      koboaController.clear();
      nauliController.clear();
      deniController.clear();
      changanyaController.clear();
      tumiziController.clear();
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
                        'New stock record',
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
                        controller: nameController,
                      ),
                      NewInputField(
                        lable: "Gunia",
                        controller: guniaController,
                      ),
                      NewInputField(
                        lable: "Koboa",
                        controller: koboaController,
                      ),
                      NewInputField(
                        lable: "Tumizi",
                        controller: tumiziController,
                      ),
                      NewInputField(
                        lable: "Deni",
                        controller: deniController,
                      ),
                      NewInputField(
                        lable: "Nauli",
                        controller: nauliController,
                      ),
                      NewInputField(
                        lable: "Kamba",
                        controller: kambaController,
                      ),
                      NewInputField(
                        lable: "Kago",
                        controller: kagoController,
                      ),
                      NewInputField(
                        lable: "Changanya",
                        controller: changanyaController,
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
                            await stock.add({
                              'full_name': nameController.text,
                              'gunia': guniaController.text,
                              'nauli': nauliController.text,
                              'changanya': changanyaController.text,
                              'kago': kagoController.text,
                              'koboa': koboaController.text,
                              'tumizi': tumiziController.text,
                              'date': formattedDate,
                              'kamba': kambaController.text,
                              'deni': deniController.text,
                              'user_id': auth.currentUser?.uid,
                              'timestamp': timestamp,
                            });
                            setState(() {
                              nameController.clear();
                              guniaController.clear();
                              kagoController.clear();
                              kambaController.clear();
                              koboaController.clear();
                              nauliController.clear();
                              deniController.clear();
                              changanyaController.clear();
                              tumiziController.clear();
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
}

class NewInputField extends StatelessWidget {
  String lable;
  TextEditingController controller;
  NewInputField({
    Key? key,
    required this.lable,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        child: TextField(
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
