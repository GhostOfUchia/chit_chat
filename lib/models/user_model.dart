class UserModel {
  String? fullname;
  String? uid;
  String? profilepic;
  String? email;

  UserModel(
      {required this.fullname,
      required this.uid,
      required this.email,
      required this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    fullname = map["fullname"];
    uid = map["uid"];
    profilepic = map["profilepic"];
    email = map["email"];
  }

  Map<String, dynamic> toMap() {
    return {
      "fullname": fullname,
      "uid": uid,
      "profilepic": profilepic,
      "email": email
    };
  }
}
