import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/pages/login_page.dart';
import 'package:chit_chat/service/show_toast.dart';
import 'package:chit_chat/service/validater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnPasswordController = TextEditingController();

  bool show = true;

  signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      showToast(ex.toString());
    }

    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel newUser =
          UserModel(fullname: "", uid: uid, email: email, profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        showToast("new User Created");
      });
      emailController.clear();
      passwordController.clear();
      cnPasswordController.clear();
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //

                  const SizedBox(
                    height: 20.0,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    validator: Validater.validateEmail,
                    decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0))),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: show,
                    validator: Validater.validatePassword,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              show = !show;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (show) ? Colors.red : Colors.black,
                          ),
                        ),
                        hintText: "Password",
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0))),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: cnPasswordController,
                    obscureText: show,
                    validator: (value) {
                      if (passwordController.text.trim() !=
                          cnPasswordController.text.trim()) {
                        return "PassWord Did Not match";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              show = !show;
                            });
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (show) ? Colors.red : Colors.black,
                          ),
                        ),
                        hintText: "ConfermPassword",
                        labelText: "ConfermPassword",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0))),
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  SizedBox(
                    height: 50,
                    width: 150,
                    child: OutlinedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUp(emailController.text.trim(),
                                passwordController.text.trim());
                          } else {
                            showToast("Please Enter All the Field");
                          }
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
                          "SignUp",
                          style: TextStyle(fontSize: 15),
                        )),
                  )
                ],
              )),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already Have a Account?"),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
