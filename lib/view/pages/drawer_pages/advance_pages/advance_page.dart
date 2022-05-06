import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/models/advance_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';
import 'package:stocksmanager/view/pages/drawer_pages/advance_pages/advance_details_page.dart';

import '../../system_app_pages/login_page.dart';
import '../../system_app_pages/search_page.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class AdvancePage extends StatefulWidget {
  @override
  _AdvancePageState createState() => _AdvancePageState();
}

class _AdvancePageState extends State<AdvancePage> {
  TextEditingController sellerController = TextEditingController();
  TextEditingController buyerController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountPaidController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var advance = FirebaseFirestore.instance.collection('advance');

  final _db = FirebaseFirestore.instance;

  Stream<List<AdvanceModel>> advanceStream() {
    try {
      return _db
          .collection("advance")
          .where("user_id", isEqualTo: auth.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<AdvanceModel> dataFromFireStore = <AdvanceModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(AdvanceModel.fromDocumentSnapshot(doc: doc));
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
    sellerController.dispose();
    buyerController.dispose();
    priceController.dispose();
    amountPaidController.dispose();
    statusController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Advance'),
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
          addAdvanceBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamBuilder<List<AdvanceModel>>(
        stream: advanceStream(),
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
                  AdvanceModel advanceSnapshot = snapshot.data![index];
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 65,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Color(0xFFF2F4F4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text('${advanceSnapshot.seller}'))),
                            Expanded(
                                child: Center(
                                    child: Text('${advanceSnapshot.buyer}'))),
                            Expanded(
                                child: Center(
                                    child:
                                        Text('${advanceSnapshot.amountPaid}'))),
                            Expanded(
                                child: Center(
                                    child: Text('${advanceSnapshot.status}'))),
                            Expanded(
                                child: Center(
                                    child: Text('${advanceSnapshot.price}'))),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvanceDetailsPage(
                                  advanceData: advanceSnapshot)));
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

  addAdvanceBottomSheets(context) {
    var timestamp = FieldValue.serverTimestamp();
    String dropdownValue = 'Office';
    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(currentDate);

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
                        'New advance record',
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
                          thickness: 0.8,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      NewInputField(
                        lable: "Seller's name",
                        controller: sellerController,
                        keyboard: TextInputType.text,
                      ),
                      NewInputField(
                        lable: "Buyer's name",
                        controller: buyerController,
                        keyboard: TextInputType.text,
                      ),
                      NewInputField(
                        lable: "Amount paid",
                        controller: amountPaidController,
                        keyboard: TextInputType.number,
                      ),
                      NewInputField(
                        lable: "Price for sale",
                        controller: priceController,
                        keyboard: TextInputType.number,
                      ),
//                      NewInputField(
//                        lable: "Status",
//                        controller: statusController,
//                        keyboard: TextInputType.text,
//                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>['Office', 'Anayo']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                            await advance.add({
                              'seller': sellerController.text,
                              'buyer': buyerController.text,
                              'amount paid': amountPaidController.text,
                              'price': priceController.text,
                              'user_id': auth.currentUser?.uid,
                              'date': formattedDate,
                              'status': dropdownValue,
                              'timestamp': timestamp,
                            });

                            sellerController.clear();
                            amountPaidController.clear();
                            priceController.clear();
                            buyerController.clear();
                            dateController.clear();
                            Navigator.pop(context);
                            Get.snackbar(
                                "Advance", "Document successfuly added.",
                                snackPosition: SnackPosition.BOTTOM,
                                borderRadius: 20,
                                duration: const Duration(seconds: 4),
                                margin: const EdgeInsets.all(15),
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                forwardAnimationCurve: Curves.easeInOutBack);
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
  String lable = '';
  NewInputField({
    Key? key,
    required this.lable,
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

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({Key? key}) : super(key: key);

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String dropdownValue = 'Office';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Office', 'Anayo']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
