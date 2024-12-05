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
    }
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
            Text(widget.targetUser.email.toString())
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(child: Container()),
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
                    const SizedBox(
                      width: 60.0,
                      child: Icon(
                        Icons.send,
                        size: 40.0,
                        color: Colors.black,
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
