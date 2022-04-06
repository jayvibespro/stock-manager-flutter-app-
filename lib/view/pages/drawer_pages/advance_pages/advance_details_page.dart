import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocksmanager/models/advance_model.dart';

import 'advance_page.dart';

class AdvanceDetailsPage extends StatefulWidget {
  final AdvanceModel? advanceData;
  AdvanceDetailsPage({Key? key, required this.advanceData}) : super(key: key);

  @override
  State<AdvanceDetailsPage> createState() => _AdvanceDetailsPageState();
}

class _AdvanceDetailsPageState extends State<AdvanceDetailsPage> {
  TextEditingController sellerController = TextEditingController();

  TextEditingController buyerController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController amountPaidController = TextEditingController();

  TextEditingController statusController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  final advance = FirebaseFirestore.instance.collection('advance');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sellerController.dispose();
    buyerController.dispose();
    priceController.dispose();
    amountPaidController.dispose();
    statusController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const Expanded(
                    child: Center(
                      child: Icon(
                        Icons.west,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Advance information',
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Seller"),
              trailing: Text("${widget.advanceData?.seller}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Buyer"),
              trailing: Text("${widget.advanceData?.buyer}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Amount"),
              trailing: Text("${widget.advanceData?.amountPaid}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Price"),
              trailing: Text("${widget.advanceData?.price}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Status"),
              trailing: Text("${widget.advanceData?.status}"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListTile(
              leading: const Text("Date"),
              trailing: Text("${widget.advanceData?.date}"),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        editAdvanceBottomSheets(context, widget.advanceData);
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        editAdvanceBottomSheets(context, widget.advanceData);
                      },
                      child: const Text(
                        'Edit info',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        advance.doc(widget.advanceData?.id).delete();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        advance.doc(widget.advanceData?.id).delete();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  editAdvanceBottomSheets(context, AdvanceModel? advanceEditData) {
    setState(() {
      sellerController.text = advanceEditData!.seller;
      buyerController.text = advanceEditData.buyer;
      amountPaidController.text = advanceEditData.amountPaid.toString();
      priceController.text = advanceEditData.price.toString();
      statusController.text = advanceEditData.status;
      dateController.text = advanceEditData.date;
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
                      AdvanceEditField(
                        hint: "${advanceEditData?.seller}",
                        lable: "seller's name",
                        controller: sellerController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Buyer's name",
                        hint: "${advanceEditData?.buyer}",
                        controller: buyerController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Amount paid",
                        hint: "${advanceEditData?.amountPaid}",
                        controller: amountPaidController,
                        keyboard: TextInputType.number,
                      ),
                      AdvanceEditField(
                        lable: "Price for sale",
                        hint: "${advanceEditData?.price}",
                        controller: priceController,
                        keyboard: TextInputType.number,
                      ),
                      AdvanceEditField(
                        lable: "Status",
                        hint: "${advanceEditData?.status}",
                        controller: statusController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Pick date",
                        hint: "${advanceEditData?.date}",
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
                            await advance.doc(advanceEditData?.id).update({
                              'seller': sellerController.text,
                              'buyer': buyerController.text,
                              'amount paid': amountPaidController.text,
                              'price': priceController.text,
                              'date': dateController.text,
                              'status': statusController.text
                            });
                            setState(() {
                              statusController.clear();
                              sellerController.clear();
                              amountPaidController.clear();
                              priceController.clear();
                              buyerController.clear();
                              dateController.clear();
                            });
                            Get.offAll(AdvancePage());
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

class AdvanceEditField extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  String lable;
  String hint;

  AdvanceEditField({
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
