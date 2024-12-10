import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  late IO.Socket socket;

  List<MessageData> messageDataList = List.empty();

  String username = "";

  void init() {
    socket = IO.io('http://128.0.1.123:3002', <String, dynamic>{
      'transports': ['websocket'],
    });

    // socket = IO.io('http://10.0.2.2:3001', <String, dynamic>{
    //   'transports': ['websocket'],
    // });

    socket.onConnect((_) {
      print('Socket connected');
      // socket.emit("serverConnect");
    });

    socket.on(
      "chat",
      (data) {
        print("Hadi ama !!!!!!!!!!!!!!");
        print(data);
        messageDataList =
            (data as List).map((x) => MessageData.fromJson(x)).toList();
        notifyListeners();
      },
    );

    socket.onDisconnect((_) {
      print('Socket disconnected');
      notifyListeners();
    });

    socket.onError((data) {
      print('Socket error: $data');
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}

class UserData {
  String username;
  String password;

  UserData({
    required this.username,
    required this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
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
