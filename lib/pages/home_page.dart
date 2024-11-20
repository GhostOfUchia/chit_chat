import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SearchPage();
          }));
        },
        child: Icon(Icons.search),
      ),
      body: SafeArea(
        child: Center(
          child: Text("home page"),
        ),
      ),
    );
  }
}
