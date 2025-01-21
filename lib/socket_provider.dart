import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SocketProvider with ChangeNotifier {
  late String myFirebaseID;

  late UserData userData;

  List<UserData> friendList = [];

  List<Map<String, String>> friendRequest = [];

  Future<void> fetchFriendList() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(myFirebaseID)
          .collection('friends')
          .get();

      List<UserData> tempFriendList = [];

      for (var doc in querySnapshot.docs) {
        final friendId = doc['friendId'];
        final friendSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .get();

        if (friendSnapshot.exists) {
          tempFriendList.add(
            UserData(
              email: friendSnapshot['email'],
              username: friendSnapshot['username'],
            ),
          );
        }
      }

      friendList = tempFriendList;
      notifyListeners();
    } catch (e) {
      print("Arkadaş listesi çekilirken hata oluştu: $e");
    }
  }

  Future<void> fetchFriendRequests() async {
    print("Burası çalıştı");
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(myFirebaseID)
          .collection('friend_requests')
          .get();

      friendRequest = querySnapshot.docs.map((doc) {
        return {
          'senderId': doc['senderId'] as String,
          'senderName': doc['senderName'] as String,
          'requestId': doc.id,
        };
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Arkadaşlık istekleri çekilirken hata oluştu: $e");
    }
  }

  Future<void> acceptFriendRequest(String senderId, String requestId) async {
    try {
      // Kullanıcıyı arkadaş listesine ekle
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myFirebaseID)
          .collection('friends')
          .doc(senderId)
          .set({'friendId': senderId});

      // Gönderenin arkadaş listesine de ekle
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friends')
          .doc(myFirebaseID)
          .set({'friendId': myFirebaseID});

      // İsteği kaldır
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myFirebaseID)
          .collection('friend_requests')
          .doc(requestId)
          .delete();

      friendRequest.removeWhere((request) => request['requestId'] == requestId);
      notifyListeners();
    } catch (e) {
      print("Arkadaşlık isteği kabul edilirken hata oluştu: $e");
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    try {
      // İsteği kaldır
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myFirebaseID)
          .collection('friend_requests')
          .doc(requestId)
          .delete();

      friendRequest.removeWhere((request) => request['requestId'] == requestId);
      notifyListeners();
    } catch (e) {
      print("Arkadaşlık isteği reddedilirken hata oluştu: $e");
    }
  }

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
