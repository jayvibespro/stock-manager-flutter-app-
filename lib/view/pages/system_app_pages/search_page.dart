import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/advance_model.dart';
import 'package:stocksmanager/view/pages/drawer_pages/advance_pages/advance_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  var advance = FirebaseFirestore.instance.collection('advance');

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  final List<AdvanceModel> advanceDataFromFireStore = <AdvanceModel>[];

  Stream<List<AdvanceModel>> advanceStream() {
    try {
      return _db
          .collection("advance")
          .where("user_id", isEqualTo: auth.currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          if (doc['seller'] == searchText) {
            advanceDataFromFireStore
                .add(AdvanceModel.fromDocumentSnapshot(doc: doc));
          }
        }
        print(advanceDataFromFireStore);
        return advanceDataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      searchController.text = '';
                    });
                  },
                  child: const Icon(Icons.cancel),
                ),
                hintText: "Search...",
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: const Icon(Icons.search),
            onTap: () {
              setState(() {
                searchText = searchController.text;
              });
              if (advanceDataFromFireStore != []) {
                setState(() {
                  searchController.clear();
                });
              } else {
                return;
              }
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
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
}
