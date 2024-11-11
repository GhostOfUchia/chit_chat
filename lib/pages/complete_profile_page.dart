import 'package:flutter/material.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(
              height: 100.0,
            ),
            GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 59.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_outline_sharp,
                      size: 60.0,
                    ),
                  )),
            ),
            const SizedBox(
              height: 60.0,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Full Name"),
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
                    "Login",
                    style: TextStyle(fontSize: 15),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
