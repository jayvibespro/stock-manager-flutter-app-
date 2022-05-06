import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stocksmanager/models/user_model.dart';
import 'package:stocksmanager/services/auth_services.dart';
import 'package:stocksmanager/view/components/drawer.dart';
import 'package:stocksmanager/view/pages/system_app_pages/login_page.dart';
import 'package:stocksmanager/view/pages/system_app_pages/search_page.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  final FirebaseAuth auth = FirebaseAuth.instance;

  var userFromFirebase = FirebaseFirestore.instance.collection('users');

  TextEditingController guniaController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> userStream() {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .snapshots()
          .map((element) {
        final List<UserModel> dataFromFireStore = <UserModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Profile'),
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
      body: StreamBuilder<List<UserModel>>(
        stream: userStream(),
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
                  UserModel? userModel = snapshot.data![index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              child: ClipOval(
                                child: Image.network(
                                  userModel.avatarUrl,
                                  fit: BoxFit.cover,
                                  width: 120.0,
                                  height: 120.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '${userModel.userId}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                Text(
                                  '${userModel.email}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                        child: Divider(),
                      ),
                      ListTile(
                        title: const Text('Name'),
                        trailing: Text('${userModel.name}'),
                      ),
                      ListTile(
                        title: const Text('Phone number'),
                        trailing: Text("${userModel.phoneNumber}"),
                      ),
                      ListTile(
                        title: const Text('Gender'),
                        trailing: Text('${userModel.gender}'),
                      ),
                      ListTile(
                        title: const Text('email'),
                        trailing: Text('${userModel.email}'),
                      ),
                      ListTile(
                        title: const Text('Location'),
                        trailing: Text('${userModel.location}'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 32),
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
                                'Edit profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(userModel: userModel)));
                          },
                        ),
                      ),
                    ],
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
