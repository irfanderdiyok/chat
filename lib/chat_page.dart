import 'package:chat/chat_provider.dart';
import 'package:chat/socket_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatID});

  final String chatID;
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

  Future<String?> getUserIdByEmail(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
    } catch (e) {
      print("Email ile kullanıcı ID alınırken hata oluştu: $e");
    }
    return null;
  }

  void sendMessage() async {
    if (myController.text.isEmpty) {
      print("Boş mesaj gönderilemez.");
      return;
    }

    String messageContent = myController.text.trim();
    myController.clear();

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatID)
          .collection('messages')
          .add({
        'sender': socketProvider.myFirebaseID,
        'content': messageContent,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Mesaj gönderildi.");
    } catch (e) {
      print("Mesaj gönderme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mesaj gönderilemedi. Lütfen tekrar deneyin.")),
      );
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
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      itemCount: chatProvider.messageDataList.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messageDataList[index];
                        final isMyMessage =
                            message.senderId == socketProvider.myFirebaseID;

                        return chatWidget(
                          message.message,
                          isMyMessage,
                          message.timestamp,
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

Widget chatWidget(
    String messageContent, bool isMyMessage, Timestamp? timestamp) {
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
            messageContent,
            style: TextStyle(
              color: isMyMessage ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            timestamp != null
                ? "${DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).hour.toString().padLeft(2, '0')}:${DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).minute.toString().padLeft(2, '0')}"
                : "Bilinmeyen zaman",
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
