import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocksmanager/models/group_message_model.dart';
import 'package:stocksmanager/models/group_model.dart';
import 'package:stocksmanager/services/group_services.dart';

class GroupChatPage extends StatefulWidget {
  GroupModel? groupModel;

  GroupChatPage({Key? key, this.groupModel}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();

  var timestamp = FieldValue.serverTimestamp();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  Stream<List<GroupMessageModel>> groupStream() {
    try {
      return _db
          .collection("groups")
          .doc(widget.groupModel?.id)
          .collection('messages')
          // .orderBy('timestamp', descending: true)
          .snapshots()
          .map((element) {
        final List<GroupMessageModel> dataFromFireStore = <GroupMessageModel>[];
        for (final DocumentSnapshot<Map<String, dynamic>> doc in element.docs) {
          dataFromFireStore
              .add(GroupMessageModel.fromDocumentSnapshot(doc: doc));
        }

        print(dataFromFireStore);
        return dataFromFireStore;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
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
            Text('${widget.groupModel?.name}'),
            const Text('description...'),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder<List<GroupMessageModel>>(
          stream: groupStream(),
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
                          GroupMessageModel? groupSnapshot =
                              snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Column(
                              crossAxisAlignment: (groupSnapshot.senderId ==
                                      auth.currentUser?.uid)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    '${groupSnapshot.message}',
                                    style: TextStyle(
                                      color: (groupSnapshot.senderId ==
                                              auth.currentUser?.uid)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (groupSnapshot.senderId ==
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
                                fillColor: Color(0xFFECF0F1),
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

                              await FirebaseFirestore.instance
                                  .collection('groups')
                                  .doc(widget.groupModel?.id)
                                  .collection('messages')
                                  .add({
                                // 'timestamp': FieldValue.serverTimestamp(),
                                'sender_id': auth.currentUser!.uid,
                                'message': _messageController.text,
                                'created_at': '12/07/2022',
                              }).then((value) {});
                              GroupService(
                                      id: widget.groupModel?.id,
                                      lastMessage: _messageController.text)
                                  .updateLastMessage();

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
