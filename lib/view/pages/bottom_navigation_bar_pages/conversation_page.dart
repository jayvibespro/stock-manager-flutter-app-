import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stocksmanager/models/group_model.dart';
import 'package:stocksmanager/models/single_chat_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/create_group_page.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/create_single_chat_page.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/group_chat_page.dart';
import 'package:stocksmanager/view/pages/bottom_navigation_bar_pages/single_chat_page.dart';
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

  Stream<List<SingleChatModel>> singleChatStream() {
    try {
      return _db
          .collection('single_chat')
          .where('members', arrayContains: auth.currentUser?.uid)
          .snapshots()
          .map((element) {
        final List<SingleChatModel> dataFromFireStore = <SingleChatModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(SingleChatModel.fromDocumentSnapshot(doc: doc));
        }
        return dataFromFireStore;
      });
    } catch (e) {
      print('Error:');
      print(e);
      rethrow;
    }
  }

  Stream<List<GroupModel>> groupStream() {
    try {
      return _db
          .collection('groups')
          .where('members', arrayContains: auth.currentUser?.uid)
          .snapshots()
          .map((element) {
        final List<GroupModel> dataFromFireStore = <GroupModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(GroupModel.fromDocumentSnapshot(doc: doc));
        }
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
                          builder: (context) => CreateSingleChatPage()));
                },
              ),
              SpeedDialChild(
                  child: const Icon(Icons.group),
                  label: 'Create Group',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateGroupPage()));
                  }),
            ],
          ),
          body: TabBarView(
            children: [
              StreamBuilder<List<SingleChatModel>>(
                stream: singleChatStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data Loaded...'),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('An Error Occurred...'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SingleChatModel? singleChatSnapshot =
                              snapshot.data![index];
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
                                      singleChatSnapshot.receiverImage,
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width: 60,
                                    ),
                                  ),
                                ),
                                title:
                                    Text("${singleChatSnapshot.receiverName}"),
                                subtitle:
                                    Text("${singleChatSnapshot.lastMessage}"),
                                trailing:
                                    Text("${singleChatSnapshot.lastDate}"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleChatPage(
                                              singleChatModel:
                                                  singleChatSnapshot)));
                                },
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('An Error Occurred...'),
                    );
                  }
                },
              ),
              StreamBuilder<List<GroupModel>>(
                stream: groupStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No data Loaded...'),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('An Error Occurred...'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          GroupModel? groupSnapshot = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F3F4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: Icon(Icons.group),
                                  ),
                                ),
                                title: Text("${groupSnapshot.name}"),
                                subtitle: Text("${groupSnapshot.lastMessage}"),
                                trailing:
                                    Text(formatter.format(DateTime.now())),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GroupChatPage(
                                              groupModel: groupSnapshot)));
                                },
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('An Error Occurred...'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
