import 'package:chat/chat_page.dart';
import 'package:chat/chat_provider.dart';
import 'package:chat/common.dart';
import 'package:chat/socket_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.fetchFriendRequests();
    socketProvider.fetchFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0, // İlk açılışta "Arkadaş Listesi" aktif
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ana Sayfa'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Arkadaş Listesi'),
              Tab(icon: Icon(Icons.person_add), text: 'Arkadaş İstekleri'),
              Tab(icon: Icon(Icons.add_circle), text: 'Arkadaş Ekle'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendListTab(),
            FriendRequestsTab(),
            AddFriendTab(),
          ],
        ),
      ),
    );
  }
}

class FriendListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        // Arkadaş listesi yoksa bir mesaj göster
        if (socketProvider.friendList.isEmpty) {
          return Center(
            child: Text(
              "Arkadaş listeniz boş.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          itemCount: socketProvider.friendList.length,
          itemBuilder: (context, index) {
            final friend = socketProvider.friendList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  friend.username![0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(friend.username ?? "Bilinmeyen Kullanıcı"),
              onTap: () async {
                String myID = socketProvider.myFirebaseID;

                String? friendID =
                    await MyFunction.getUserIdByEmail(friend.email!);

                if (friendID == null) {
                  print("Arkadaş bulunamadı");
                  return;
                }

                String chatID = getChatId(myID, friendID);

                ChatProvider chatProvider =
                    Provider.of<ChatProvider>(context, listen: false);

                chatProvider.listenToMessages(chatID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(chatID: chatID),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String getChatId(String user1, String user2) {
    List<String> users = [user1.toLowerCase(), user2.toLowerCase()];
    users.sort();
    return users.join("_");
  }
}

//  return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//           itemCount: socketProvider.friendList.length,
//           itemBuilder: (context, index) {
//             final friend = socketProvider.friendList[index];
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.blue,
//                 child: Text(
//                   friend.username![0].toUpperCase(),
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               title: Text(friend.username ?? "Bilinmeyen Kullanıcı"),
//               // subtitle: Text(friend.status ?? "Durum bilgisi yok"),
//               // trailing: Icon(
//               //   friend.status == 'Çevrimiçi'
//               //       ? Icons.circle
//               //       : Icons.circle_outlined,
//               //   color:
//               //       friend.status == 'Çevrimiçi' ? Colors.green : Colors.grey,
//               //   size: 12,
//               // ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatPage(friendEmail: friend.email!),
//                   ),
//                 );
//               },
//             );
//           },
//         );

class FriendRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          itemCount: socketProvider.friendRequest.length,
          itemBuilder: (context, index) {
            final request = socketProvider.friendRequest[index];
            return GestureDetector(
              onTap: () {
                _showFriendRequestPopup(
                  context,
                  request['senderName']!,
                  request['senderId']!,
                  request['requestId']!,
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    request['senderName']![0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(request['senderName']!),
                subtitle: Text('Arkadaşlık İsteği Gönderdi'),
                trailing: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showFriendRequestPopup(
      BuildContext context, String name, String senderId, String requestId) {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$name'),
          content:
              Text('Bu isteği kabul etmek veya reddetmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await socketProvider.rejectFriendRequest(requestId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name reddedildi')),
                );
              },
              child: Text("Reddet", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await socketProvider.acceptFriendRequest(senderId, requestId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name kabul edildi')),
                );
              },
              child: Text("Kabul Et", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}

class AddFriendTab extends StatefulWidget {
  @override
  State<AddFriendTab> createState() => _AddFriendTabState();
}

class _AddFriendTabState extends State<AddFriendTab> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Arkadaş eklemek isteğin kişinin e-mail adresini girin.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'E-mail Adresi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final socketProvider =
                    Provider.of<SocketProvider>(context, listen: false);

                addFriendByEmail(socketProvider.myFirebaseID,
                    socketProvider.userData.username!, email.text, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Arkadaşlık İsteği Yolla',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addFriendByEmail(
      String senderId, String senderName, String receiverEmail, context) async {
    BuildContext popUp = context;
    Common().showLoading(context, popUp);

    String? receiverId = await MyFunction.getUserIdByEmail(receiverEmail);

    if (receiverId != null) {
      await sendFriendRequest(senderId, senderName, receiverId, context);
    } else {
      Navigator.of(context).pop();
      await Common().showErrorDialog(
          "Arkadaş Ekleme Başarısız", "Kullanıcı bulunamadı", context);
      print("Kullanıcı bulunamadı");
    }
  }

  Future<void> sendFriendRequest(String senderId, String senderName,
      String receiverId, BuildContext context) async {
    try {
      // Zaten arkadaş mı kontrol et
      final existingFriend = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friends')
          .where('friendId', isEqualTo: senderId)
          .get();

      if (existingFriend.docs.isNotEmpty) {
        Navigator.of(context).pop();
        await Common().showErrorDialog(
          "Arkadaş Ekleme Başarısız",
          "Bu kullanıcı zaten arkadaşınız.",
          context,
        );
        print("Bu kullanıcı zaten arkadaşınız.");
        return;
      }

      // Daha önce istek gönderilmiş mi kontrol et
      final existingRequest = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friend_requests')
          .where('senderId', isEqualTo: senderId)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        Navigator.of(context).pop();
        await Common().showErrorDialog(
          "Arkadaş Ekleme Başarısız",
          "Bu kullanıcıya zaten bir arkadaşlık isteği gönderilmiş.",
          context,
        );
        print("Bu kullanıcıya zaten bir arkadaşlık isteği gönderilmiş.");
        return;
      }

      // Arkadaşlık isteği gönder
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friend_requests')
          .add({'senderId': senderId, 'senderName': senderName});

      Navigator.of(context).pop();
      await Common().showErrorDialog(
        "Başarılı",
        "Arkadaşlık isteği gönderildi.",
        context,
      );
      print("Arkadaşlık isteği gönderildi.");
    } catch (e) {
      print("Arkadaşlık isteği gönderilirken hata oluştu: $e");
      await Common().showErrorDialog(
        "Hata",
        "Arkadaşlık isteği gönderilirken bir sorun oluştu.",
        context,
      );
    }
  }
}
