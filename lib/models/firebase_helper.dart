import 'package:chit_chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseHelper {
  static Future<UserModel?> getUserById(String id) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    if (documentSnapshot.data() != null) {
      userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
