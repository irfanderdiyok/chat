import 'package:flutter/material.dart';

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
    {'name': 'İrfan Derdiyok', 'status': 'Çevrimiçi'},
    {'name': 'Emrah Horsunlu', 'status': 'Son görülme: 2 saat önce'},
    {'name': 'Hasan Games', 'status': 'Çevrimdışı'},
    {'name': 'Ferdi Tayfur', 'status': 'Çevrimiçi'},
    {'name': 'John Cena', 'status': 'Son görülme: 10 dakika önce'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
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
        );
      },
    );
  }
}

class FriendRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bekleyen Arkadaşlık İstekleri',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddFriendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Arkadaş Ekle',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
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