import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? profileImage; // this is for profileImage
  TextEditingController fullName =
      TextEditingController(); // this is for full name

// step one show opeation for taking pic
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
