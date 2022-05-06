import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/user_model.dart';

class CreateGroupPage extends StatefulWidget {
  UserModel? usersModel;

  CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  var message = FirebaseFirestore.instance.collection('message');
  var conversation = FirebaseFirestore.instance.collection('conversation');
  TextEditingController messageController = TextEditingController();
  var timestamp = FieldValue.serverTimestamp();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  final List<UserModel> groupMembers = [];

  Stream<List<UserModel>> usersStream() {
    try {
      return _db
          .collection("users")
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

  selectCurrentUser() {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: auth.currentUser?.uid)
          .snapshots()
          .map((element) {
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          groupMembers.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        print(groupMembers);
        return groupMembers;
      });
    } catch (e) {
      rethrow;
    }
  }

  selectOtherUsers(String userId) {
    try {
      return _db
          .collection("users")
          .where('user_id', isEqualTo: userId)
          .snapshots()
          .map((element) {
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          groupMembers.add(UserModel.fromDocumentSnapshot(doc: doc));
        }
        print(groupMembers);
        return groupMembers;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    selectCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.west),
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Select members',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 140,
              child: StreamBuilder<List<UserModel>>(
                stream: usersStream(),
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
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          UserModel? userSnapshot = snapshot.data![index];
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 40,
                                      child: ClipOval(
                                        child: Image.network(
                                          userSnapshot.avatarUrl,
                                          fit: BoxFit.cover,
                                          width: 160.0,
                                          height: 160.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('${userSnapshot.name}'),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                groupMembers.forEach((element) {
                                  if (element.userId == userSnapshot.userId) {
                                    return;
                                  }
                                });
                                selectOtherUsers(userSnapshot.userId);
                              });
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
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 16, 20, 0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Group name',
                    label: Text('Group name'),
                    border: InputBorder.none),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Divider(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groupMembers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.network(
                          groupMembers[index].avatarUrl,
                          fit: BoxFit.cover,
                          width: 120.0,
                          height: 120.0,
                        ),
                      ),
                    ),
                    title: Text("${groupMembers[index].name}"),
                    subtitle: Text("${groupMembers[index].email}"),
                    trailing:
                        (groupMembers[index].userId == auth.currentUser!.uid)
                            ? const Text('Admin')
                            : const Text(''),
                  );
                },
              ),
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
                      'Create group',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
