import 'package:chat/common.dart';
import 'package:chat/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user?.uid)
          .set({
        'email': email.text.trim(),
        'username': username.text.trim(),
      });

      Navigator.of(context).pop();

      // Başarılı işlem
      await Common().showErrorDialog("Başarılı", "Kayıt Başarılı", context);
      MyFunction.changePagePushReplacement(LoginScreen(), context);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      String errorMessage = "Kayıt işlemi sırasında bir hata oluştu.";
      if (e.code == 'email-already-in-use') {
        errorMessage =
            "Kullanmak istediğiniz e-posta adresi daha önce kullanılmış.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Şifre çok zayıf. Daha güçlü bir şifre seçin.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz bir e-posta adresi girdiniz.";
      }

      print(e);

      await Common().showErrorDialog("Başarısız", errorMessage, context);
    } catch (e) {
      Navigator.of(context).pop();
      await Common().showErrorDialog(
        "Başarısız",
        "Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.",
        context,
      );
    }
  }
}
