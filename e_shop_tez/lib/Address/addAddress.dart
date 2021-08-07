import 'package:e_shop_tez/Address/address.dart';
import 'package:e_shop_tez/Counters/totalMoney.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:e_shop_tez/Store/storehome.dart';
import 'package:flutter/material.dart';

import 'package:e_shop_tez/Config/config.dart';
import 'package:e_shop_tez/Models/address.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  double width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            width: width,
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
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                phoneNumber: cPhoneNumber.text.trim(),
                flatNumber: cFlatHomeNumber.text.trim(),
                city: cCity.text.trim(),
                pincode: cPinCode.text.trim(),
              ).toJson();

              // Firestore'a ekleme
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                Fluttertoast.showToast(msg: "Adres başarıyla eklendi.");
                //  FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
                Route route = MaterialPageRoute(builder: (c) => HomePage());
                Navigator.pushReplacement(context, route);
              });
              Route route = MaterialPageRoute(builder: (c) => HomePage());
              Navigator.push(context, route);
            }
          },
          label: Text("Ekle"),
          backgroundColor: Colors.deepOrangeAccent,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Yeni Adres Ekle",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "İsim",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Telefon Numarası",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Apartman Numarası / Daire Numarası ",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "İl / İlçe / Mahalle",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "Ülke",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Posta Kodu",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const MyTextField({
    Key key,
    this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(
          hintText: hint,
        ),
        validator: (value) => value.isEmpty ? "Bu alan boş olamaz" : null,
      ),
    );
  }
}
