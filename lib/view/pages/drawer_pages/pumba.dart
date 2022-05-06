import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/hero/hero_dialog_route.dart';
import 'package:stocksmanager/models/pumba_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';

import '../system_app_pages/login_page.dart';
import '../system_app_pages/search_page.dart';

class PumbaPage extends StatefulWidget {
  @override
  _PumbaPageState createState() => _PumbaPageState();
}

class _PumbaPageState extends State<PumbaPage> {
  var pumba = FirebaseFirestore.instance.collection('pumba');
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController guniaController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  Stream<List<PumbaModel>> pumbaStream() {
    try {
      return _db
          .collection("pumba")
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<PumbaModel> dataFromFireStore = <PumbaModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(PumbaModel.fromDocumentSnapshot(doc: doc));
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

    guniaController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Pumba'),
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
          addPumbaBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: Stack(
        children: [
          StreamBuilder<List<PumbaModel>>(
            stream: pumbaStream(),
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
                      PumbaModel? pumbaModel = snapshot.data![index];
                      return Padding(
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
                              Text('${pumbaModel.date}'),
                              Text('${pumbaModel.gunia}'),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD5DBDB),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 8, 30, 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          HeroDialogRoute(
                                            builder: (context) => Center(
                                              child: AddPumbaPopupCard(
                                                  pumbaModel: pumbaModel),
                                            ),
                                            settings: const RouteSettings(),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: 'pumbaHeroTag',
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFD5DBDB),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 8, 30, 8),
                                            child: const Text('Add'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await pumba.doc(pumbaModel.id).delete();
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
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text('An Error Occured...'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  addPumbaBottomSheets(context) {
    var timestamp = FieldValue.serverTimestamp();

    DateTime currentDate = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(currentDate);

    setState(() {
      guniaController.clear();
    });

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
                        'New Pumba record',
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
                        lable: "Idadi ya gunia",
                        inputType: TextInputType.number,
                        controller: guniaController,
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
                            await pumba.add({
                              'gunia': guniaController.text,
                              'date': formattedDate,
                              'timestamp': timestamp,
                              'user_id': auth.currentUser?.uid,
                            });

                            setState(() {
                              guniaController.clear();
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
  TextInputType inputType;

  NewInputField({
    Key? key,
    required this.lable,
    required this.inputType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        child: TextField(
          controller: controller,
          keyboardType: inputType,
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

class AddPumbaPopupCard extends StatelessWidget {
  PumbaModel? pumbaModel;

  AddPumbaPopupCard({required this.pumbaModel});

  var pumba = FirebaseFirestore.instance.collection('pumba');

  @override
  Widget build(BuildContext context) {
    TextEditingController adderController = TextEditingController();
    return SingleChildScrollView(
      child: Hero(
        tag: 'pumbaHeroTag',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFD5DBDB),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Gunia za pumba',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                      child: Divider(),
                    ),
                    Center(
                      child: Text(
                        '${pumbaModel?.gunia}',
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4),
                      child: TextField(
                        autofocus: true,
                        controller: adderController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          fillColor: Color(0xFFD5DBDB),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                      child: Divider(),
                    ),
                    TextButton(
                      onPressed: () async {
                        int newValue;

                        if (pumbaModel?.gunia == null) {
                          newValue = int.parse(adderController.text);

                          await pumba.doc(pumbaModel?.id).set({
                            'gunia': adderController.text,
                          });
                          Get.snackbar("Info",
                              "${adderController.text} Kg added to the previous amount.",
                              snackPosition: SnackPosition.BOTTOM,
                              borderRadius: 20,
                              duration: const Duration(seconds: 4),
                              margin: const EdgeInsets.all(15),
                              isDismissible: true,
                              dismissDirection: DismissDirection.horizontal,
                              forwardAnimationCurve: Curves.easeInOutBack);
                        } else {
                          newValue = int.parse(pumbaModel!.gunia) +
                              int.parse(adderController.text);
                        }

                        await pumba.doc(pumbaModel?.id).update({
                          'gunia': newValue.toString(),
                        });
                        Navigator.pop(context);
                        Get.snackbar("Info",
                            "${adderController.text} added to the previous amount.",
                            snackPosition: SnackPosition.BOTTOM,
                            borderRadius: 20,
                            duration: const Duration(seconds: 4),
                            margin: const EdgeInsets.all(15),
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            forwardAnimationCurve: Curves.easeInOutBack);
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
