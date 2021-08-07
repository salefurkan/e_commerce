import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Authentication/authenication_register.dart';
import 'package:e_shop_tez/DialogBox/errorDialog.dart';
import 'package:e_shop_tez/DialogBox/loadingDialog.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:e_shop_tez/animation/animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:e_shop_tez/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  String email, password;

  var _formKey = GlobalKey<FormState>();
  bool loadingState = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: loadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                              0.6,
                              Text(
                                "Giriş Yap",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                              0.7,
                              Text(
                                "Tekrar Hoş Geldiniz",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
                                              color: Color.fromRGBO(
                                                  225, 95, 27, .3),
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
                                                        color:
                                                            Colors.grey[200]))),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: (obj) {
                                                return obj.contains("@")
                                                    ? null
                                                    : "Geçerli email adresi yazınız";
                                              },
                                              onChanged: (obj) {
                                                setState(() {
                                                  email = obj;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Email adresinizi giriniz.",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.grey[200]))),
                                            child: TextFormField(
                                              validator: (obj) {
                                                return obj.length >= 6
                                                    ? null
                                                    : "Şifreniz minimum 6 karakter olmalı.";
                                              },
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
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
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
                                          ? loginUp()
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                SizedBox(
                                  height: 40,
                                ),
                                FadeAnimation(
                                  1.0,
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                            builder: (_) => RegisterPage());
                                        Navigator.pushReplacement(
                                            context, route);
                                      },
                                      child: Text(
                                        "Üye değil misin? Üye Ol",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUp() async {
    showDialog(
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
    }
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
      List<String> favList =
          dataSnapshot.data[EcommerceApp.userFavList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userFavList, favList);
    });
  }
}
