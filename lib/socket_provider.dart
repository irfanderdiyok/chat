import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  late IO.Socket socket;

  String username = "";

  late UserData userData;

  List<UserData> friendList = List.empty();

  List<UserData> friendRequest = List.empty();

  List<MessageData> messageDataList = [];

  void addMessage() {
    notifyListeners();
  }

  void init() {
    // socket = IO.io('http://128.0.1.123:3002', <String, dynamic>{
    //   'transports': ['websocket'],
    // });

    socket = IO.io('http://10.0.2.2:3002', <String, dynamic>{
      'transports': ['websocket'],
    });

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

    socket.on(
      "myFrindList",
      (data) {
        friendRequest =
            (data as List).map((x) => UserData.fromJson(x)).toList();
        notifyListeners();
      },
    );

    socket.on(
      "requestList",
      (data) {
        friendList = (data as List).map((x) => UserData.fromJson(x)).toList();
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
  String? email;
  String? username;
  String password;

  UserData({
    this.email,
    this.username,
    required this.password,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
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


  // void connectSocket() {
  //   socket = IO.io(
  //       'http://10.0.2.2:3000',
  //       IO.OptionBuilder()
  //           .setTransports(['websocket'])
  //           .disableAutoConnect()
  //           .build());

  //   socket.connect();
  //   socket.onConnect((_) {
  //     debugPrint('connect');
  //     socket.emit('sendUserData', {"dataUsername": "test5"});
  //     socket.on('chat', (data) {
  //       final Map<String, dynamic> result = data;

  //       socketModels.add(result);
  //       setState(() {});
  //     });
  //   });
  // }