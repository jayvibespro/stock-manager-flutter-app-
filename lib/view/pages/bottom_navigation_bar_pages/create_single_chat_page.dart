import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/user_model.dart';
import 'package:stocksmanager/services/single_chat_service.dart';

class CreateSingleChatPage extends StatefulWidget {
  UserModel? usersModel;

  @override
  _CreateSingleChatPageState createState() => _CreateSingleChatPageState();
}

class _CreateSingleChatPageState extends State<CreateSingleChatPage> {
  TextEditingController _messageController = TextEditingController();
  // var timestamp = FieldValue.serverTimestamp();
  String receiverId = '';
  String receiverName = 'Recipient:';
  String receiverEmail = '';
  String receiverImage = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  List<String> members = [];

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
                      child: Text('An Error Occurred...'),
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
                                receiverEmail = userSnapshot.email;
                              });
                              setState(() {
                                receiverImage = userSnapshot.avatarUrl;
                              });
                            },
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('An Error Occurred...'),
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
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Text message',
                        fillColor: const Color(0xFFECF0F1),
                        filled: true,
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_messageController.text == '') return;

                      setState(() {
                        members = [auth.currentUser!.uid, receiverId];
                      });

                      SingleChatService(
                        members: members,
                        lastMessage: _messageController.text,
                        lastDate: '07/05/2022',
                        receiverName: receiverName,
                        receiverImage: receiverImage,
                        receiverEmail: receiverEmail,
                        message: _messageController.text,
                        senderId: auth.currentUser?.uid,
                        date: '06/05/2022',
                      ).createChat();
                      print('here no doc id found');
                      var docInstance = await FirebaseFirestore.instance
                          .collection('single_chat')
                          .where('members',
                              arrayContains: auth.currentUser?.uid)
                          // .where('members', arrayContains: receiverId)
                          .get();

                      String docId = '';

                      docInstance.docs.forEach((element) {
                        setState(() {
                          docId = element.id;
                        });
                      });
                      print('single chat Id:');
                      print(docId);

                      setState(() {
                        _messageController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      radius: 28.0,
                      backgroundColor: Color(0xFFECF0F1),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
