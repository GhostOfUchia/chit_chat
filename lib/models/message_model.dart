class MessageModel {
  String? sender;
  String? message;
  bool? seen;
  DateTime? createdon;

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    message = map["message"];
    seen = map["seen"];
    createdon = map["createdon"];
  }

 Map<String,dynamic> toMap() {
    return {
      "sender": sender,
      "message": message,
      "seen": seen,
      "createdon": createdon
    };
  }
}
