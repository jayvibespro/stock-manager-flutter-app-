import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocksmanager/hero/hero_dialog_route.dart';
import 'package:stocksmanager/models/machine_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';

import '../system_app_pages/login_page.dart';
import '../system_app_pages/search_page.dart';

class MachinePage extends StatefulWidget {
  @override
  _MachinePageState createState() => _MachinePageState();
}

class _MachinePageState extends State<MachinePage> {
  var machineKg = FirebaseFirestore.instance.collection('machine_kg');

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController kgController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  Stream<List<MachineModel>> machineKgStream() {
    try {
      return _db
          .collection("machine_kg")
          .where('user_id', isEqualTo: auth.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<MachineModel> dataFromFireStore = <MachineModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(MachineModel.fromDocumentSnapshot(doc: doc));
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
    kgController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Machine Kg'),
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
          addMachineKgBottomSheets(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
      body: Stack(
        children: [
          StreamBuilder<List<MachineModel>>(
            stream: machineKgStream(),
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
                      MachineModel? machineModel = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFECF0F1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${machineModel.fullName}'),
                                  Text('${machineModel.date}'),
                                  Container(
                                    child: machineModel.isDone
                                        ? Row(
                                            children: const [
                                              Icon(
                                                Icons.task_alt,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: const [
                                              Icon(
                                                Icons.pending,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'Pending',
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${machineModel.kg}',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            HeroDialogRoute(
                                              builder: (context) => Center(
                                                child: AddMachineKgPopupCard(
                                                    machineModel: machineModel),
                                              ),
                                              settings: const RouteSettings(),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: 'machineHeroTag',
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
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 8, 30, 8),
                                              child: const Text('Add'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: IconButton(
                                          alignment: Alignment.bottomCenter,
                                          onPressed: () {
                                            setState(() {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  25.0),
                                                        ),
                                                      ),
                                                      child: Wrap(
                                                        children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Text(
                                                              'More options',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                const Divider(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        0),
                                                            child: ListTile(
                                                              leading:
                                                                  const Icon(
                                                                      Icons
                                                                          .edit),
                                                              title: const Text(
                                                                  'Edit'),
                                                              onTap: () {
                                                                editAdvanceBottomSheets(
                                                                    context,
                                                                    machineModel);
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        0),
                                                            child: ListTile(
                                                              leading: const Icon(
                                                                  Icons.delete),
                                                              title: const Text(
                                                                  'Delete'),
                                                              onTap: () async {
                                                                await machineKg
                                                                    .doc(
                                                                        machineModel
                                                                            .id)
                                                                    .delete();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        0),
                                                            child:
                                                                machineModel
                                                                        .isDone
                                                                    ? null
                                                                    : ListTile(
                                                                        leading:
                                                                            const Icon(
                                                                          Icons
                                                                              .done,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        title: const Text(
                                                                            'Done'),
                                                                        onTap:
                                                                            () async {
                                                                          await machineKg
                                                                              .doc(machineModel.id)
                                                                              .update({
                                                                            'isDone':
                                                                                true,
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            });
                                          },
                                          icon: const Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Icon(Icons.more_vert)),
                                        ),
                                      ),
                                    ],
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

  addMachineKgBottomSheets(context) {
    var timestamp = FieldValue.serverTimestamp();

    setState(() {
      nameController.clear();
      kgController.text = '0';
      dateController.clear();
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
                        'Kilo za mashine',
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
                        lable: "Full name",
                        controller: nameController,
                        keyboard: TextInputType.text,
                      ),
                      NewInputField(
                        lable: "Kilo",
                        controller: kgController,
                        keyboard: TextInputType.number,
                      ),
                      NewInputField(
                        lable: "Pick date",
                        controller: dateController,
                        keyboard: TextInputType.datetime,
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
                            await machineKg.add({
                              'user_id': auth.currentUser?.uid,
                              'full_name': nameController.text,
                              'kg': kgController.text,
                              'date': dateController.text,
                              'isDone': false,
                              'timestamp': timestamp,
                            });

                            setState(() {
                              nameController.clear();
                              kgController.clear();
                              dateController.clear();
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

  editAdvanceBottomSheets(context, MachineModel? machineKgEditData) {
    setState(() {
      nameController.text = machineKgEditData!.fullName;
      kgController.text = machineKgEditData.kg;
      dateController.text = machineKgEditData.date;
    });

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.west,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Text(
                              'Edit record',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
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
                      MachineEditField(
                        hint: "${machineKgEditData?.fullName}",
                        lable: "Full name",
                        controller: nameController,
                        keyboard: TextInputType.text,
                      ),
                      MachineEditField(
                        lable: "Kilo",
                        hint: "${machineKgEditData?.kg}",
                        controller: kgController,
                        keyboard: TextInputType.number,
                      ),
                      MachineEditField(
                        lable: "Pick date",
                        hint: "${machineKgEditData?.date}",
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
                            await machineKg.doc(machineKgEditData?.id).update({
                              'full_name': nameController.text,
                              'kg': kgController.text,
                              'date': dateController.text,
                            });
                            setState(() {
                              nameController.clear();
                              kgController.clear();
                              dateController.clear();
                            });
                            Get.offAll(MachinePage());
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
  TextInputType keyboard;

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

class MachineEditField extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  String lable;
  String hint;

  MachineEditField({
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

class AddMachineKgPopupCard extends StatelessWidget {
  MachineModel? machineModel;

  AddMachineKgPopupCard({required this.machineModel});

  var machineKg = FirebaseFirestore.instance.collection('machine_kg');

  @override
  Widget build(BuildContext context) {
    TextEditingController adderController = TextEditingController();
    return SingleChildScrollView(
      child: Hero(
        tag: 'machineHeroTag',
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
                        'Add machine Kg',
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
                        '${machineModel?.kg}',
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

                        if (machineModel?.kg == null) {
                          newValue = int.parse(adderController.text);

                          await machineKg.doc(machineModel?.id).set({
                            'kg': adderController.text,
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
                          newValue = int.parse(machineModel!.kg) +
                              int.parse(adderController.text);
                        }

                        await machineKg.doc(machineModel?.id).update({
                          'kg': newValue.toString(),
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
