import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<MessageData> messageDataList = [];

  void listenToMessages(String chatId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      messageDataList = snapshot.docs.map((doc) {
        return MessageData(
          message: doc['content'],
          senderId: doc['sender'],
          timestamp: doc['timestamp'] as Timestamp,
        );
      }).toList();
      notifyListeners();
    });
  }
}

class MessageData {
  String message;
  String senderId;
  Timestamp timestamp;

  MessageData({
    required this.message,
    required this.senderId,
    required this.timestamp,
  });
}
