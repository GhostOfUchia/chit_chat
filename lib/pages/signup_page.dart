import 'package:chit_chat/validater.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    controller: emailController,
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
                    validator: Validater.validatePassword,
                    decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
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
                        onPressed: () {},
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
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already Have a Account?"),
            Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
