import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Appbar(),
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.yellow,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Appbar extends StatelessWidget {
  const Appbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print("Merhaba dünya");
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
              size: 30,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: 36,
                child: Image.asset(
                  "assets/Oval.png",
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Martha Craig",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "tap here for contact",
                    style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 60,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  print("Merhaba dünya");
                },
                icon: Icon(
                  Icons.camera,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  print("Merhaba dünya");
                },
                icon: Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
