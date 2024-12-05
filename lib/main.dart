import 'package:chit_chat/models/firebase_helper.dart';
import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/pages/home_page.dart';
import 'package:chit_chat/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';

var uuid = const Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel? myUserModle = await FireBaseHelper.getUserById(currentUser.uid);
    if (myUserModle != null) {
      runApp(ChatAppLoggedIn(
        userModel: myUserModle,
        firebaseUser: currentUser,
      ));
    }
  } else {
    runApp(const ChatApp());
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class ChatAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ChatAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        userModel: userModel,
        firebaseUser: firebaseUser,
      ),
    );
  }
}
