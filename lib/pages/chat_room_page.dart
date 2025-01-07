import 'package:chit_chat/main.dart';
import 'package:chit_chat/models/chatroom_model.dart';
import 'package:chit_chat/models/message_model.dart';
import 'package:chit_chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chatRoomModel,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController msgController = TextEditingController();

  void sendMessage() {
    String msg = msgController.text.trim();
    msgController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        message: msg,
        seen: false,
        createdon: DateTime.now(),
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
    } // why we shoud not use await because some case internet not working and
    // our firebase will support ofline messageing

    widget.chatRoomModel.lastMessage = msg;
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatRoomModel.chatroomid)
        .set(widget.chatRoomModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              child: Icon(Icons.person),
            ),
            const SizedBox(
              width: 30.0,
            ),
            Text(widget.targetUser.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoomModel.chatroomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot currentSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        reverse: true,
                        itemCount: currentSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessageModel =
                              MessageModel.fromMap(currentSnapshot.docs[index]
                                  .data() as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: (currentMessageModel.sender ==
                                    widget.userModel.uid)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Text(
                                  currentMessageModel.message.toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An Error Accured ! Please Check Your Internet "),
                      );
                    } else {
                      return const Center(
                        child: Text("Say Hi To Your New Friend"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: msgController,
                        decoration: InputDecoration(
                            hintText: "Write Here",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18.0))),
                      ),
                    ),
                    SizedBox(
                      width: 60.0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 40.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          sendMessage();
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
