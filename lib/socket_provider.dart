import 'package:flutter/material.dart';

class SocketProvider with ChangeNotifier {
  late String myFirebaseID;

  late UserData userData;

  List<UserData> friendList = List.empty();

  List<UserData> friendRequest = List.empty();

  List<MessageData> messageDataList = [];

  void addMessage() {
    notifyListeners();
  }

  void init() {}

  @override
  void dispose() {
    super.dispose();
  }
}

class UserData {
  String? email;
  String? username;

  UserData({
    this.email,
    this.username,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'] ?? '', // null kontrolü
      username: json['username'] ?? '', // null kontrolü
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
    };
  }
}

class MessageData {
  String message;
  String sender;

  MessageData({
    required this.message,
    required this.sender,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      message: json['message'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
    };
  }
}
