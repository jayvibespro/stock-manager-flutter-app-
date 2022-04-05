import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocksmanager/models/stock_model.dart';
import 'package:stocksmanager/view/pages/drawer_pages/stock_pages/stock_page.dart';

class StockDetailsPage extends StatefulWidget {
  final StockModel? stockData;
  StockDetailsPage({Key? key, required this.stockData}) : super(key: key);

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  final stock = FirebaseFirestore.instance.collection('stock');

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
                      'Stock information',
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
          ListTile(
            leading: const Text("Full name"),
            trailing: Text("${widget.stockData?.fullName}"),
          ),
          ListTile(
            leading: const Text("Gunia"),
            trailing: Text("${widget.stockData?.gunia}"),
          ),
          ListTile(
            leading: const Text("Deni"),
            trailing: Text("${widget.stockData?.deni}"),
          ),
          ListTile(
            leading: const Text("Nauli"),
            trailing: Text("${widget.stockData?.nauli}"),
          ),
          ListTile(
            leading: const Text("Tumizi"),
            trailing: Text("${widget.stockData?.tumizi}"),
          ),
          ListTile(
            leading: const Text("Koboa"),
            trailing: Text("${widget.stockData?.koboa}"),
          ),
          ListTile(
            leading: const Text("Kago"),
            trailing: Text("${widget.stockData?.kago}"),
          ),
          ListTile(
            leading: const Text("Kamba"),
            trailing: Text("${widget.stockData?.kamba}"),
          ),
          ListTile(
            leading: const Text("Changanya"),
            trailing: Text("${widget.stockData?.changanya}"),
          ),
          ListTile(
            leading: const Text("Date"),
            trailing: Text("${widget.stockData?.date}"),
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
                        editStockBottomSheets(context, widget.stockData);
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        editStockBottomSheets(context, widget.stockData);
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
                        stock.doc(widget.stockData?.id).delete();
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
                        stock.doc(widget.stockData?.id).delete();
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

  editStockBottomSheets(context, StockModel? stockEditData) {
    setState(() {
      nameController.text = stockEditData!.fullName;
      guniaController.text = stockEditData.gunia;
      nauliController.text = stockEditData.nauli;
      changanyaController.text = stockEditData.changanya;
      koboaController.text = stockEditData.koboa;
      dateController.text = stockEditData.date;
      kagoController.text = stockEditData.kago;
      tumiziController.text = stockEditData.tumizi;
      kambaController.text = stockEditData.kamba;
      deniController.text = stockEditData.deni;
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
                        hint: "${stockEditData?.fullName}",
                        lable: "Full name",
                        controller: nameController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Gunia",
                        hint: "${stockEditData?.gunia}",
                        controller: guniaController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Deni",
                        hint: "${stockEditData?.deni}",
                        controller: deniController,
                        keyboard: TextInputType.number,
                      ),
                      AdvanceEditField(
                        lable: "Nauli",
                        hint: "${stockEditData?.nauli}",
                        controller: nauliController,
                        keyboard: TextInputType.number,
                      ),
                      AdvanceEditField(
                        lable: "Tumizi",
                        hint: "${stockEditData?.tumizi}",
                        controller: tumiziController,
                        keyboard: TextInputType.text,
                      ),
                      AdvanceEditField(
                        lable: "Koboa",
                        hint: "${stockEditData?.koboa}",
                        controller: koboaController,
                        keyboard: TextInputType.datetime,
                      ),
                      AdvanceEditField(
                        lable: "Kago",
                        hint: "${stockEditData?.kago}",
                        controller: kagoController,
                        keyboard: TextInputType.datetime,
                      ),
                      AdvanceEditField(
                        lable: "Kamba",
                        hint: "${stockEditData?.kamba}",
                        controller: kambaController,
                        keyboard: TextInputType.datetime,
                      ),
                      AdvanceEditField(
                        lable: "Changanya",
                        hint: "${stockEditData?.changanya}",
                        controller: changanyaController,
                        keyboard: TextInputType.datetime,
                      ),
                      AdvanceEditField(
                        lable: "Pick date",
                        hint: "${stockEditData?.date}",
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
                            await stock.doc(stockEditData?.id).update({
                              'full_name': nameController.text,
                              'gunia': guniaController.text,
                              'nauli': nauliController.text,
                              'changanya': changanyaController.text,
                              'kago': kagoController.text,
                              'koboa': koboaController.text,
                              'tumizi': tumiziController.text,
                              'date': dateController.text,
                              'kamba': kambaController.text,
                              'deni': deniController.text,
                            });

                            setState(() {
                              nameController.clear();
                              guniaController.clear();
                              kagoController.clear();
                              kambaController.clear();
                              koboaController.clear();
                              nauliController.clear();
                              dateController.clear();
                              deniController.clear();
                              changanyaController.clear();
                              tumiziController.clear();
                            });

                            Get.offAll(StockPage());
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
