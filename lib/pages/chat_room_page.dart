import 'package:chit_chat/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  // final ChatRoomModel chatRoomModel;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      //  required this.chatRoomModel,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        //  controller: searchController,
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
