import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/single_chat_message_model.dart';
import 'package:stocksmanager/models/single_chat_model.dart';
import 'package:stocksmanager/services/single_chat_service.dart';

class SingleChatPage extends StatefulWidget {
  SingleChatModel? singleChatModel;

  SingleChatPage({Key? key, this.singleChatModel}) : super(key: key);

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  TextEditingController _messageController = TextEditingController();

  var timestamp = FieldValue.serverTimestamp();

  final FirebaseAuth auth = FirebaseAuth.instance;

  // String? chatDocId = '';

  Stream<List<SingleChatMessageModel>> singleChatMessageStream() {
    final _db = FirebaseFirestore.instance;

    try {
      return _db
          .collection("single_chat")
          .doc(widget.singleChatModel?.id)
          .collection('messages')
//          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<SingleChatMessageModel> dataFromFireStore =
            <SingleChatMessageModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(SingleChatMessageModel.fromDocumentSnapshot(doc: doc));
        }

        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  // void checkConversation() async {
  //   await chats
  //       .where('users', isEqualTo: {
  //         widget.userModel!.userId: null,
  //         auth.currentUser!.uid: null
  //       })
  //       .limit(1)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //         if (querySnapshot.docs.isNotEmpty) {
  //           setState(() {
  //             chatDocId = querySnapshot.docs.single.id;
  //           });
  //
  //           print('present id: $chatDocId');
  //         } else if (querySnapshot.docs.isEmpty) {
  //           chats.add({
  //             'users': {
  //               widget.userModel!.userId: null,
  //               auth.currentUser!.uid: null
  //             }
  //           }).then((value) {
  //             setState(() {
  //               chatDocId = value.id;
  //             });
  //             print("DocId:" + chatDocId!);
  //           });
  //         } else {
  //           return;
  //         }
  //       })
  //       .catchError((error) {});
  // }

  @override
  void initState() {
    // checkConversation();
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
            Text('${widget.singleChatModel?.receiverName}'),
            Text('${widget.singleChatModel?.receiverEmail}'),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<List<SingleChatMessageModel>>(
          stream: singleChatMessageStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        reverse: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SingleChatMessageModel? singleChatMessageSnapshot =
                              snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Column(
                              crossAxisAlignment:
                                  (singleChatMessageSnapshot.senderId ==
                                          auth.currentUser?.uid)
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '${singleChatMessageSnapshot.message}',
                                    style: TextStyle(
                                      color:
                                          (singleChatMessageSnapshot.senderId ==
                                                  auth.currentUser?.uid)
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        (singleChatMessageSnapshot.senderId ==
                                                auth.currentUser?.uid)
                                            ? const Color(0xFF4DDC6E)
                                            : const Color(0xFFECF0F1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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
                                fillColor: const Color(0xFFECF0F1),
                                filled: true,
                              ),
                              minLines: 1,
                              maxLines: 5,
                              controller: _messageController,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                          child: TextButton(
                            onPressed: () async {
                              if (_messageController.text == '') return;
                              SingleChatService(
                                id: widget.singleChatModel?.id,
                                message: _messageController.text,
                                senderId: auth.currentUser?.uid,
                                date: '06/05/2022',
                              ).sendMessage();

                              SingleChatService(
                                id: widget.singleChatModel?.id,
                                lastMessage: _messageController.text,
                                lastDate: '06/05/2022',
                                receiverEmail:
                                    widget.singleChatModel?.receiverEmail,
                                receiverImage:
                                    widget.singleChatModel?.receiverImage,
                                receiverName:
                                    widget.singleChatModel?.receiverName,
                              ).updateChat();
                              setState(() {
                                _messageController.clear();
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
                child: Text('An error occurred...'),
              );
            }
          },
        ),
      ),
    );
  }
}
