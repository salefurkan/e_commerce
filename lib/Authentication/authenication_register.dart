import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Authentication/authenication_login.dart';
import 'package:e_shop_tez/DialogBox/errorDialog.dart';
import 'package:e_shop_tez/DialogBox/loadingDialog.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:e_shop_tez/animation/animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:e_shop_tez/Config/config.dart';

class RegisterPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<RegisterPage> {
  String email, password, userImageUrl = "";
  File _imageFile;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900],
              Colors.orange[800],
              Colors.orange[400]
            ],
          ),
        ),
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
                        1,
                        Text(
                          "Kayıt Ol",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Hoş Geldiniz",
                          style: TextStyle(color: Colors.white, fontSize: 18),
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
                          FadeAnimation(
                            0.5,
                            InkWell(
                              onTap: () {
                                _selectAndPickImage();
                              },
                              child: CircleAvatar(
                                radius: screenWidth * 0.15,
                                backgroundColor: Colors.white70,
                                backgroundImage: _imageFile == null
                                    ? null
                                    : FileImage(_imageFile),
                                child: _imageFile == null
                                    ? Icon(
                                        Icons.add_a_photo_outlined,
                                        size: screenWidth * 0.15,
                                        color: Colors.orange[600],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                              1.4,
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]),
                                        ),
                                      ),
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
                                          hintText: "Email adresinizi giriniz.",
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
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30.0,
                          ),
                          FadeAnimation(
                            1.6,
                            GestureDetector(
                              onTap: () {
                                uploadAndSaveImage();
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]),
                                child: Center(
                                  child: Text(
                                    "Kayıt Ol",
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
                            1.8,
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AuthenticScreen()),
                                      (Route route) => false);
                                },
                                child: Text(
                                  "Üye misin? Giriş Yap ",
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

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Lütfen profil fotoğrafı seçiniz.",
            );
          });
    } else {
      uploadToStorage();
    }
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingAlertDialog(
          message: "Üyelik yapılıyor, lütfen bekleyiniz.",
        );
      },
    );
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((url) {
      userImageUrl = url;
    });
    registerUser();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      firebaseUser = value.user;
    }).catchError((onError) {
      if (onError.toString() ==
          "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)") {
        Fluttertoast.showToast(msg: "Mail Hesabı Zaten Kayıtlı");
      }
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser firebaseUser) async {
    Firestore.instance.collection("users").document(firebaseUser.uid).setData({
      "uid": firebaseUser.uid,
      "email": firebaseUser.email,
      "username": firebaseUser.email.split('@')[0],
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
      EcommerceApp.userFavList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString("uid", firebaseUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, firebaseUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, firebaseUser.email.split('@')[0]);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userFavList, ["garbageValue"]);
  }
}
