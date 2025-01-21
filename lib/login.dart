import 'package:chat/common.dart';
import 'package:chat/home.dart';

import 'package:chat/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

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
                  postLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  MyFunction.changePagePushReplacement(
                      RegisterScreen(), context);
                },
                child: Text(
                  'Hesabın yok mu? Kayıt Ol.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postLogin() async {
    List<TextEditingController> controllers = [
      email,
      password,
    ];

    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        Common().showErrorDialog(
          "Giriş Başarısız",
          "Bütün alanları doldurduğunuzdan emin olun.",
          context,
        );
        return;
      }
    }

    BuildContext popUp = context;
    Common().showLoading(context, popUp);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      Navigator.of(context).pop();

      await Common().showErrorDialog("Başarılı", "Giriş Başarılı", context);
      MyFunction.changePagePushReplacement(HomePage(), context);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      String errorMessage = "Giriş sırasında bir hata oluştu.";
      if (e.code == 'user-not-found') {
        errorMessage = "E-posta adresine ait kullanıcı bulunamadı.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Yanlış şifre girdiniz.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz bir e-posta adresi girdiniz.";
      }

      await Common().showErrorDialog("Başarısız", errorMessage, context);
    } catch (e) {
      Navigator.of(context).pop();
      await Common().showErrorDialog("Başarısız",
          "Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.", context);
    }
  }
}
