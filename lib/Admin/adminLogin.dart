import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Admin/uploadItems.dart';
import 'package:e_shop_tez/Authentication/authenication_login.dart';
import 'package:e_shop_tez/Widgets/customTextField.dart';
import 'package:e_shop_tez/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Authentication/authenication_register.dart';
import 'package:e_shop_tez/DialogBox/loadingDialog.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:e_shop_tez/Store/storehome.dart';
import 'package:e_shop_tez/animation/animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop_tez/Config/config.dart';

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  @override
  String email, password;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange[900],
          Colors.orange[800],
          Colors.orange[400]
        ])),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      0.4,
                      Image.asset("images/admin.png"),
                    ),
                    FadeAnimation(
                      0.6,
                      Center(
                        child: Text(
                          "Mağaza Yönetim Paneli",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        0.7,
                        Center(
                          child: Text(
                            "Hoş Geldiniz",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          FadeAnimation(
                              0.8,
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        onChanged: (obj) {
                                          setState(() {
                                            email = obj;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              "Kullanıcı kodunuzu giriniz.",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        onChanged: (obj) {
                                          setState(() {
                                            password = obj;
                                          });
                                        },
                                        obscureText: true,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                            hintText: "Şifre",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            0.9,
                            GestureDetector(
                              onTap: () {
                                email.isNotEmpty && password.isNotEmpty
                                    ? loginAdmin()
                                    : showDialog(
                                        context: context,
                                        builder: (c) {
                                          return ErrorAlertDialog(
                                            message:
                                                "Lütfen email ve şifrenizi giriniz.",
                                          );
                                        });
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]),
                                child: Center(
                                  child: Text(
                                    "Giriş Yap",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data["id"] != email || result.data["password"] != password) {
          if (result.data["id"] == email) {
            Fluttertoast.showToast(
                msg: "Kullanıcı adı veya şifrenizi kontrol ediniz.");
          }
        } else if (result.data["id"] == email &&
            result.data["password"] == password) {
          Fluttertoast.showToast(
              msg: "Hoş geldiniz, sayın " + result.data["name"] + ".");

          setState(() {
            email = "";
            password = "";
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadPage(),
                ));
          });
        } else {
          Fluttertoast.showToast(msg: "Bilinmeyen bir hata meydana geldi.");
        }
      });
    });

    /*showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Giriş yapılıyor, lütfen  bekleyiniz.",
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => firebaseUser = value.user)
        .catchError((onError) {
      print(onError.toString());
      if (onError.toString() ==
          "PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null, null)") {
        Fluttertoast.showToast(msg: "E-mail veya şifre hatalı");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Bilinmeyen bir hata meydana geldi.");
        Navigator.pop(context);
      }
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      });
    }*/
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
