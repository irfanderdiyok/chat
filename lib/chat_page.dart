import 'dart:io';

import 'package:chat/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late SocketProvider socketProvider;
  List<Map<String, dynamic>> socketModels = List.empty();
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    socketProvider = Provider.of<SocketProvider>(context, listen: false);
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

  void sendMessage() {
    if (myController.text.isNotEmpty) {
      MessageData messageData = new MessageData(
        message: myController.text,
        sender: socketProvider.username,
      );
      socketProvider.socket.emit('chat', messageData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesajlaşma Sayfası"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
                child: Consumer<SocketProvider>(
                  builder: (context, socketProvider, child) {
                    return ListView.builder(
                      itemCount: socketProvider.messageDataList.length,
                      itemBuilder: (context, index) {
                        return chatWidget(
                          socketProvider.messageDataList[index],
                          context,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myController,
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(Icons.send)),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  labelText: "Mesajınızı girin",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget chatWidget(MessageData messageData, BuildContext context) {
  String username =
      Provider.of<SocketProvider>(context, listen: false).username;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: messageData.sender == username
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: SizedBox(
        width: 200,
        child: Card(
          elevation: 10,
          color: Colors.greenAccent,
          shadowColor: Colors.black26,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(5), right: Radius.circular(5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      messageData.message,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "15.02.2023",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
