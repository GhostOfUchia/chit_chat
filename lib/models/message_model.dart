class MessageModel {
  String? messageid;
  String? sender;
  String? message;
  bool? seen;
  DateTime? createdon;

  MessageModel(
      {required this.messageid,
      required this.sender,
      required this.message,
      required this.seen,
      required this.createdon});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    message = map["message"];
    seen = map["seen"];
    createdon = map["createdon"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "message": message,
      "seen": seen,
      "createdon": createdon
    };
  }
}
