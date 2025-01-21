import 'package:chat/chat_page.dart';
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
              // subtitle: Text(friend.status ?? "Durum bilgisi yok"),
              // trailing: Icon(
              //   friend.status == 'Çevrimiçi'
              //       ? Icons.circle
              //       : Icons.circle_outlined,
              //   color:
              //       friend.status == 'Çevrimiçi' ? Colors.green : Colors.grey,
              //   size: 12,
              // ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(friendName: friend.username!),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

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

                addFriendByEmail(
                  socketProvider.myFirebaseID,
                  socketProvider.userData.username!,
                  email.text,
                );
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
      String senderId, String senderName, String receiverEmail) async {
    String? receiverId = await getUserIdByEmail(receiverEmail);

    if (receiverId != null) {
      await sendFriendRequest(senderId, senderName, receiverId);
    } else {
      print("Kullanıcı bulunamadı");
    }
  }

  Future<void> sendFriendRequest(
      String senderId, String senderName, String receiverId) async {
    final existingRequest = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('friend_requests')
        .where('senderId', isEqualTo: senderId)
        .get();

    if (existingRequest.docs.isNotEmpty) {
      print("Bu kullanıcıya zaten bir arkadaşlık isteği gönderilmiş.");
      return;
    }

    // Arkadaşlık isteği gönder
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('friend_requests')
        .add({'senderId': senderId, 'senderName': senderName});

    print("Arkadaşlık isteği gönderildi.");
  }

  Future<String?> getUserIdByEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }
}
