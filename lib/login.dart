import 'package:chat/chat_page.dart';
import 'package:chat/common.dart';
import 'package:chat/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login Page"),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          myInputField("Username", username),
          myInputField("Password", password),
          ElevatedButton(
            onPressed: postLogin,
            child: Text("Login"),
          ),
        ],
      ),
    );
  }

  Future<void> postLogin() async {
    List<TextEditingController> controllers = [
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

    UserData userData = UserData(
      username: username.text,
      password: password.text,
    );
    print("okey");
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    bool result = false;
    await socketProvider.socket.emitWithAckAsync(
      'login',
      userData,
      ack: (data) {
        result = data;
        socketProvider.username = username.text;
      },
    );
    Navigator.of(context).pop();

    if (result) {
      await Common().showErrorDialog("Başarılı", "Giriş Başarılı", context);
      MyFunction.changePage(ChatPage(), context);
    } else {
      await Common().showErrorDialog("Başarısız", "Giriş Başarısız", context);
    }

    // Navigator.pop(context);
  }

  Widget myInputField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}

class MyFunction {
  static void changePage(StatefulWidget statefulWidget, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
    );
  }
}
