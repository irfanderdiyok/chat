import 'package:chat/chat_page.dart';
import 'package:chat/common.dart';
import 'package:chat/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  final List<Map<String, String>> friends = [
    {'name': 'Ahmet Yılmaz', 'status': 'Çevrimiçi'},
    {'name': 'Mehmet Kaya', 'status': 'Son görülme: 2 saat önce'},
    {'name': 'Elif Demir', 'status': 'Çevrimdışı'},
    {'name': 'Ayşe Arslan', 'status': 'Çevrimiçi'},
    {'name': 'Deniz Şahin', 'status': 'Son görülme: 10 dakika önce'},
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          itemCount: 5, //socketProvider.friendList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  friends[index]['name']![0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(friends[index]['name']!),
              subtitle: Text(friends[index]['status']!),
              trailing: Icon(
                friends[index]['status'] == 'Çevrimiçi'
                    ? Icons.circle
                    : Icons.circle_outlined,
                color: friends[index]['status'] == 'Çevrimiçi'
                    ? Colors.green
                    : Colors.grey,
                size: 12,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatPage(friendName: friends[index]['name']!),
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
  final List<Map<String, String>> friendRequests = [
    {'name': 'Ahmet Yılmaz', 'status': 'Arkadaşlık İsteği Gönderdi'},
    {'name': 'Mehmet Kaya', 'status': 'Arkadaşlık İsteği Gönderdi'},
    {'name': 'Elif Demir', 'status': 'Arkadaşlık İsteği Gönderdi'},
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          itemCount: 3,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showFriendRequestPopup(
                  context,
                  friendRequests[index]['name']!,
                  friendRequests[index]['status']!,
                );
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    friendRequests[index]['name']![0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(friendRequests[index]['name']!),
                subtitle: Text(friendRequests[index]['status']!),
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
      BuildContext context, String name, String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$name'),
          content: Text(
              '$status\nBu isteği kabul etmek veya reddetmek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop-up'ı kapat
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name reddedildi')),
                );
              },
              child: Text("Reddet", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Pop-up'ı kapat
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
                postRegister();
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

  Future<void> postRegister() async {
    List<TextEditingController> controllers = [
      email,
    ];

    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        Common().showErrorDialog(
          "Kayıt Başarısız",
          "Bütün alanları doldurduğunuzdan emin olun.",
          context,
        );
        return;
      }
    }

    BuildContext popUp = context;
    Common().showLoading(context, popUp);

    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    bool result = false;
    // await socketProvider.socket.emitWithAckAsync(
    //   'sendFriendRequest',
    //   email.text,
    //   ack: (data) {
    //     result = data;
    //   },
    // );
    Navigator.of(context).pop();

    if (result) {
      await Common().showErrorDialog("Başarılı", "Kayıt Başarılı", context);
    } else {
      await Common().showErrorDialog(
          "Başarısız",
          "Kullanmak istediğiniz e-mail adresi daha önce kullanılmış.",
          context);
    }

    // Navigator.pop(context);
  }
}




//  child: Consumer<SocketProvider>(
//           builder: (context, socketProvider, child) {
//             return ListView.builder(
//               itemCount: socketProvider.mevlutDataList.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 120,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Mevlüt Adı : " +
//                           socketProvider.mevlutDataList[index].mevlutAdi),
//                       Text("Mevlüt Yemeği : " +
//                           socketProvider.mevlutDataList[index].mevlutYemegi),
//                       Text("Mevlüt Adresi : " +
//                           socketProvider.mevlutDataList[index].mevlutAdresi),
//                       Text("Mevlüt Başlangıç : " +
//                           socketProvider
//                               .mevlutDataList[index].neZamanBaslayacak),
//                       Text("Mevlüt Bitiş : " +
//                           socketProvider.mevlutDataList[index].neZamanBitecek),
//                       SizedBox(
//                         height: context.dynamicHeight(0.01),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),