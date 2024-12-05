import 'dart:developer';

import 'package:chit_chat/main.dart';
import 'package:chit_chat/models/chatroom_model.dart';
import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/pages/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroom(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var snapdata = snapshot.docs[0].data();
      ChatRoomModel exitingchatroomModel =
          ChatRoomModel.fromMap(snapdata as Map<String, dynamic>);
      chatRoom = exitingchatroomModel;
      log("chat room found");
    } else {
      ChatRoomModel newchatRoomModel = ChatRoomModel(
          chatroomid: uuid.v1(),
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          },
          lastMessage: "");
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newchatRoomModel.chatroomid)
          .set(newchatRoomModel.toMap());
      chatRoom = newchatRoomModel;
      log("new chatroom created");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chit-Chat"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Enter Email",
                    labelText: "Enter Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: OutlinedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18), // Your desired shape with round corners
                    ), // Border color
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchController.text)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot userSanpShot =
                            snapshot.data as QuerySnapshot;
                        if (userSanpShot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = userSanpShot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searchUser = UserModel.fromMap(userMap);
                          return ListTile(
                            onTap: () async {
                              log("method run");
                              ChatRoomModel? chatroomModel =
                                  await getChatroom(searchUser);
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoomPage(
                                  targetUser: searchUser,
                                  chatRoomModel: chatroomModel!,
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                );
                              }));
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(searchUser.email!),
                            trailing: const Icon(Icons.keyboard_arrow_right),
                          );
                        } else {
                          return const Text("No result found");
                        }
                      } else if (snapshot.hasError) {
                        return const Text("No result found");
                      } else {
                        return const Text("No result found");
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            )
          ],
        )));
  }
}
