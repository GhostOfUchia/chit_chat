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
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoomPage(
                                  targetUser: searchUser,
                                  // chatRoomModel: ,
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
