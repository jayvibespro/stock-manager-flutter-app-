import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/user_model.dart';

class SelectUsersPage extends StatefulWidget {
  UserModel? usersModel;

  @override
  _SelectUsersPageState createState() => _SelectUsersPageState();
}

class _SelectUsersPageState extends State<SelectUsersPage> {
  var message = FirebaseFirestore.instance.collection('message');
  var conversation = FirebaseFirestore.instance.collection('conversation');
  TextEditingController messageController = TextEditingController();
  var timestamp = FieldValue.serverTimestamp();
  String receiverId = 'receiver-id';
  String receiverName = 'Recepient:';
  String senderName = 'userName';

  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<UserModel>> usersStream() {
    final _db = FirebaseFirestore.instance;

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.west),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select a friend',
                style: TextStyle(fontSize: 34),
              ),
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
                                  Text('${userSnapshot.name}'),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                receiverId = userSnapshot.userId;
                              });
                              setState(() {
                                receiverName = userSnapshot.name;
                              });
                              setState(() {
                                senderName = auth.currentUser!.email!;
                              });
                              print(senderName);
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${receiverName}',
                    style: const TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                  const Icon(Icons.person),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Divider(),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                  )),
                  IconButton(
                    onPressed: () async {
                      await message.add({
                        'sender_id': auth.currentUser?.uid,
                        'receiver_id': receiverId,
                        'message': messageController.text,
                        'timestamp': timestamp,
                      });

                      await conversation.add({
                        'sender_id': auth.currentUser?.uid,
                        'receiver_id': receiverId,
                        'last_message': messageController.text,
                        'timestamp': timestamp,
                        'sender_name': auth.currentUser?.email,
                        'receiver_name': receiverName,
                      });

                      setState(() {
                        messageController.clear();
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
