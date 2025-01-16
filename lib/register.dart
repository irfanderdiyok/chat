import 'package:chat/chat_page.dart';
import 'package:chat/common.dart';
import 'package:chat/home.dart';
import 'package:chat/login.dart';
import 'package:chat/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mesajlaşma Uygulaması',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
              SizedBox(height: 20),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 30),
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
                  'Kayıt Ol',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  MyFunction.changePagePushReplacement(LoginScreen(), context);
                },
                child: Text(
                  'Hesabın var mı? Giriş Yap.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postRegister() async {
    List<TextEditingController> controllers = [
      email,
      username,
      password,
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

    await Future.delayed(Duration(seconds: 2));

    UserData userData = UserData(
      email: email.text,
      username: username.text,
      password: password.text,
    );
    print("okey");
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    bool result = true;
    // await socketProvider.socket.emitWithAckAsync(
    //   'register',
    //   userData,
    //   ack: (data) {
    //     result = data;
    //     socketProvider.username = username.text;
    //   },
    // );

    Navigator.of(context).pop();

    if (result) {
      await Common().showErrorDialog("Başarılı", "Kayıt Başarılı", context);
      MyFunction.changePagePushReplacement(LoginScreen(), context);
    } else {
      await Common().showErrorDialog(
          "Başarısız",
          "Kullanmak istediğiniz e-mail adresi daha önce kullanılmış.",
          context);
    }

    // Navigator.pop(context);
  }
}
