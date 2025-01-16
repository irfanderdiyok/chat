import 'package:chat/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.friendName});

  final String friendName;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late SocketProvider socketProvider;
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
  }

  void sendMessage() {
    if (myController.text.isNotEmpty) {
      MessageData messageData = MessageData(
        message: myController.text,
        sender: socketProvider.username,
      );

      MessageData messageData2 = MessageData(
        message: myController.text,
        sender: "socketProvider.username",
      );

      socketProvider.messageDataList.add(messageData);
      socketProvider.messageDataList.add(messageData2);
      socketProvider.addMessage();

      // socketProvider.socket.emit('chat', messageData);
      myController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesajlaşma"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: Consumer<SocketProvider>(
                  builder: (context, socketProvider, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Mesaj yaz...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
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
  bool isMyMessage = messageData.sender == username;

  return Align(
    alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: isMyMessage ? Colors.deepPurple : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: isMyMessage ? const Radius.circular(12) : Radius.zero,
          bottomRight: isMyMessage ? Radius.zero : const Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageData.message,
            style: TextStyle(
              color: isMyMessage ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "15.02.2023", // Tarihi dinamik yapabilirsin
            style: TextStyle(
              fontSize: 12,
              color: isMyMessage ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}
