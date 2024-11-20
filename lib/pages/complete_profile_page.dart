// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chit_chat/models/user_model.dart';
import 'package:chit_chat/pages/home_page.dart';
import 'package:chit_chat/service/show_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const CompleteProfilePage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? profileImage; // this is for profileImage
  TextEditingController fullName =
      TextEditingController(); // this is for full name

//   Circul Avater Clicking step=>    step one show opeation for taking pic
  showImageOpeation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Seclet Imaage"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    secletImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select Image From Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    secletImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text("Take a Image From camera"),
                )
              ],
            ),
          );
        });
  }

  // step two => Seclet image
  secletImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      cropImage(pickedImage);
    }
  }

  // step three => CropedImage for  fit in our imageWiget
  cropImage(XFile file) async {
    CroppedFile? cropedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (cropedImage != null) {
      setState(() {
        profileImage = File(cropedImage.path);
      });
    }
  }

  // Submit button Clicking step
  // setp one => checkValue
  checkValue() {
    String name = fullName.text.trim();
    if (name == "" || profileImage == null) {
      showToast("Please Enter All The Fields ");
    } else {
      uploadData();
    }
  }

  // step Two => upload Data
  uploadData() async {
    // set up our storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("ProfilePic")
        .child(widget.userModel.uid.toString())
        .putFile(profileImage!);

    // we can wait to get upload task complete and get tasksnapshot
    TaskSnapshot taskSnapshot = await uploadTask;

    // download image url for saving firebasecloudfirestore
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    String userName = fullName.text.trim();

    widget.userModel.profilepic = imageUrl;
    widget.userModel.fullname = userName;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage(
          userModel: widget.userModel,
          firebaseUser: widget.firebaseUser,
        );
      }));
    });
  }

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
              onTap: () {
                showImageOpeation();
              },
              child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                      radius: 59.0,
                      backgroundColor: Colors.white,
                      backgroundImage: (profileImage != null)
                          ? FileImage(profileImage!)
                          : null,
                      child: (profileImage == null)
                          ? const Icon(
                              Icons.person_outline_sharp,
                              size: 60.0,
                            )
                          : null)),
            ),
            const SizedBox(
              height: 60.0,
            ),
            TextFormField(
              controller: fullName,
              decoration: const InputDecoration(hintText: "Full Name"),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: OutlinedButton(
                  onPressed: () {
                    checkValue();
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
                    "Submit",
                    style: TextStyle(fontSize: 15),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
