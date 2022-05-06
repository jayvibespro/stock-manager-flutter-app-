import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/models/user_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/chat_page.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/create_group_page.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/select_users_page.dart';
import 'package:stocksmanager/view/pages/system_app_pages/login_page.dart';
import 'package:stocksmanager/view/pages/system_app_pages/search_page.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  DateFormat formatter = DateFormat('dd/MM/yyyy');

  Stream<List<UserModel>> userStream() {
    try {
      return _db
          .collection('users')
          .where('user_id', isNotEqualTo: auth.currentUser?.uid)
          .snapshots()
          .map((element) {
        final List<UserModel> dataFromFireStore = <UserModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        print(dataFromFireStore);
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  final isDailOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          if (isDailOpen.value) {
            isDailOpen.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          drawer: NewDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: const Text('Chat'),
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
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                ),
                Tab(
                  icon: Icon(Icons.group),
                ),
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            backgroundColor: Colors.amberAccent,
            spaceBetweenChildren: 12,
            spacing: 12,
            overlayOpacity: 0.00,
            overlayColor: Colors.transparent,
            openCloseDial: isDailOpen,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.chat),
                label: 'Start Chat',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectUsersPage()));
                },
              ),
              SpeedDialChild(
                  child: const Icon(Icons.group), label: 'Create Group',
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateGroupPage()));
                  }
                  ),
            ],
          ),
          body: TabBarView(
            children: [
              StreamBuilder<List<UserModel>>(
                stream: userStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data Loaded...'),
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
                          UserModel? userSnapshot = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F3F4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Image.network(
                                      userSnapshot.avatarUrl,
                                      fit: BoxFit.cover,
                                      width: 120.0,
                                      height: 120.0,
                                    ),
                                  ),
                                ),
                                title: Text("${userSnapshot.name}"),
                                subtitle: Text("last message goes here."),
                                trailing:
                                    Text(formatter.format(DateTime.now())),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                              userModel: userSnapshot)));
                                },
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
              const Center(
                child: Text('groups'),
              ),
            ],
          ),
        ),
      ),
    );
  }
//  addAdvanceBottomSheets(context) {
//    var timestamp = FieldValue.serverTimestamp();
//    String dropdownValue = 'Office';
//    DateTime currentDate = DateTime.now();
//    DateFormat formatter = DateFormat('dd/MM/yyyy');
//    String formattedDate = formatter.format(currentDate);
//
//    return showModalBottomSheet(
//        backgroundColor: Colors.transparent,
//        isScrollControlled: true,
//        context: context,
//        builder: (context) {
//          return Padding(
//            padding: const EdgeInsets.fromLTRB(0, 84, 0, 0),
//            child: Container(
//              height: double.infinity,
//              decoration: const BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(25.0),
//                  topRight: Radius.circular(25.0),
//                ),
//              ),
//              child: SingleChildScrollView(
//                child: Padding(
//                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      GestureDetector(
//                        child: const Icon(
//                          Icons.west,
//                        ),
//                        onTap: () {
//                          Navigator.pop(context);
//                        },
//                      ),
//                      const SizedBox(
//                        height: 30,
//                      ),
//                      const Text(
//                        'New advance record',
//                        style: TextStyle(
//                          fontSize: 30,
//                        ),
//                      ),
//                      const SizedBox(
//                        height: 30,
//                      ),
//                      const Padding(
//                        padding: EdgeInsets.all(8.0),
//                        child: Divider(
//                          color: Colors.black54,
//                          thickness: 0.8,
//                        ),
//                      ),
//                      const SizedBox(
//                        height: 30,
//                      ),
//                      NewInputField(
//                        lable: "Seller's name",
//                        controller: sellerController,
//                        keyboard: TextInputType.text,
//                      ),
//                      NewInputField(
//                        lable: "Buyer's name",
//                        controller: buyerController,
//                        keyboard: TextInputType.text,
//                      ),
//                      NewInputField(
//                        lable: "Amount paid",
//                        controller: amountPaidController,
//                        keyboard: TextInputType.number,
//                      ),
//                      NewInputField(
//                        lable: "Price for sale",
//                        controller: priceController,
//                        keyboard: TextInputType.number,
//                      ),
////                      NewInputField(
////                        lable: "Status",
////                        controller: statusController,
////                        keyboard: TextInputType.text,
////                      ),
//                      Container(
//                        width: double.infinity,
//                        padding: const EdgeInsets.all(8),
//                        child: DropdownButton<String>(
//                          value: dropdownValue,
//                          icon: const Icon(Icons.arrow_drop_down_circle),
//                          elevation: 16,
//                          style: const TextStyle(color: Colors.deepPurple),
//                          onChanged: (String? newValue) {
//                            setState(() {
//                              dropdownValue = newValue!;
//                            });
//                          },
//                          items: <String>['Office', 'Anayo']
//                              .map<DropdownMenuItem<String>>((String value) {
//                            return DropdownMenuItem<String>(
//                              value: value,
//                              child: Text(value),
//                            );
//                          }).toList(),
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
//                        child: GestureDetector(
//                          child: Container(
//                            width: double.infinity,
//                            height: 60,
//                            padding: const EdgeInsets.all(8),
//                            decoration: BoxDecoration(
//                              color: Colors.amberAccent,
//                              borderRadius: BorderRadius.circular(10),
//                              boxShadow: const [
//                                BoxShadow(
//                                  color: Color.fromRGBO(143, 148, 251, 1),
//                                  blurRadius: 10.0,
//                                  offset: Offset(2, 6),
//                                ),
//                              ],
//                            ),
//                            child: const Center(
//                              child: Text(
//                                'Done',
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 20,
//                                  fontWeight: FontWeight.bold,
//                                  letterSpacing: 1,
//                                ),
//                              ),
//                            ),
//                          ),
//                          onTap: () async {
//                            await advance.add({
//                              'seller': sellerController.text,
//                              'buyer': buyerController.text,
//                              'amount paid': amountPaidController.text,
//                              'price': priceController.text,
//                              'user_id': auth.currentUser?.uid,
//                              'date': formattedDate,
//                              'status': dropdownValue,
//                              'timestamp': timestamp,
//                            });
//
//                            sellerController.clear();
//                            amountPaidController.clear();
//                            priceController.clear();
//                            buyerController.clear();
//                            dateController.clear();
//                            Navigator.pop(context);
//                            Get.snackbar(
//                                "Advance", "Document successfuly added.",
//                                snackPosition: SnackPosition.BOTTOM,
//                                borderRadius: 20,
//                                duration: const Duration(seconds: 4),
//                                margin: const EdgeInsets.all(15),
//                                isDismissible: true,
//                                dismissDirection: DismissDirection.horizontal,
//                                forwardAnimationCurve: Curves.easeInOutBack);
//                          },
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          );
//        });
////  await Future.delayed(Duration(seconds: 5));
////  Navigator.pop(context);
//  }
}
