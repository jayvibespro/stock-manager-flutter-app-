import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/chat_model.dart';
import 'package:stocksmanager/models/user_model.dart';

class ChatPage extends StatefulWidget {
  UserModel? userModel;

  ChatPage({Key? key, this.userModel}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  var timestamp = FieldValue.serverTimestamp();

  final FirebaseAuth auth = FirebaseAuth.instance;

  var chats = FirebaseFirestore.instance.collection('chats');

  String? chatDocId = '';

  final _db = FirebaseFirestore.instance;

  Stream<List<ChatModel>> chatStream() {
    final List<ChatModel> dataFromFireStore = <ChatModel>[];

    try {
      return _db
          .collection("message")
//          .where("receiver_id", isEqualTo: auth.currentUser?.uid)
//          .where('sender_id', isEqualTo: widget.userModel?.receiverId)
//          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore.add(ChatModel.fromDocumentSnapshot(doc: doc));
        }

        print(dataFromFireStore);
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  void checkConversation() async {
    await chats
        .where('users', isEqualTo: {
          widget.userModel!.userId: null,
          auth.currentUser!.uid: null
        })
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              chatDocId = querySnapshot.docs.single.id;
            });

            print('present id: $chatDocId');
          } else if (querySnapshot.docs.isEmpty) {
            chats.add({
              'users': {
                widget.userModel!.userId: null,
                auth.currentUser!.uid: null
              }
            }).then((value) {
              setState(() {
                chatDocId = value.id;
              });
              print("DocId:" + chatDocId!);
            });
          } else {
            return;
          }
        })
        .catchError((error) {});
  }

  @override
  void initState() {
    checkConversation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${widget.userModel?.name}'),
            Text('${widget.userModel?.email}'),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var data;
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occured...'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('Loading...'),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('Say Hi!'),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      reverse: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        data = document;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Column(
                            crossAxisAlignment:
                                (data!['sender_id'] == auth.currentUser?.uid)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '${data!['message']}',
                                  style: TextStyle(
                                    color: (data!['sender_id'] ==
                                            auth.currentUser?.uid)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (data!['sender_id'] ==
                                          auth.currentUser?.uid)
                                      ? const Color(0xFF4DDC6E)
                                      : const Color(0xFFECF0F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                hintText: 'Text message',
                                fillColor: Color(0xFFECF0F1),
                                filled: true,
                              ),
                              minLines: 1,
                              maxLines: 5,
                              controller: messageController,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: TextButton(
                            onPressed: () async {
                              if (messageController.text == '') return;

                              await chats
                                  .doc(chatDocId)
                                  .collection('messages')
                                  .add({
                                'timestamp': FieldValue.serverTimestamp(),
                                'sender_id': auth.currentUser!.uid,
                                'message': messageController.text,
                              }).then((value) {
                                setState(() {
                                  messageController.clear();
                                });
                              });
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
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('An error occured...'),
              );
            }
          },
        ),
      ),
    );
  }
}
