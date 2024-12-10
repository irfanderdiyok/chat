import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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