import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_shop_tez/Config/config.dart';
import 'package:e_shop_tez/Counters/changeAddresss.dart';
import 'package:e_shop_tez/Models/address.dart';
import 'package:e_shop_tez/Orders/placeOrderPayment.dart';
import 'package:e_shop_tez/Widgets/loadingWidget.dart';
import 'package:e_shop_tez/Widgets/wideButton.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  const Address({
    Key key,
    this.totalAmount,
  }) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}

double width;

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Adres Seç",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(
              builder: (context, address, c) {
                return Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .document(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    adressId:
                                        snapshot.data.docs()[index].documentID,
                                    totalAmount: widget.totalAmount,
                                    model: AddressModel.fromJson(
                                        snapshot.data.docs()[index].data),
                                  );
                                },
                              );
                  },
                ));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Yeni Adres Ekle"),
          backgroundColor: Colors.deepOrangeAccent,
          icon: Icon(Icons.add_location),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, route);
          },
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.deepOrange.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white),
            Text("Kargo adresi kaydedilmedi."),
            Text("Lütfen kargo yapmamız için adresinizi girin."),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final bool ctrl;
  final AddressModel model;
  final String adressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  const AddressCard({
    Key key,
    this.ctrl,
    this.model,
    this.adressId,
    this.totalAmount,
    this.currentIndex,
    this.value,
  }) : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.deepOrangeAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                  activeColor: Colors.deepOrange,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Ad",
                              ),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Telefon Numarası",
                              ),
                              Text(widget.model.phoneNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Daire Numarası",
                              ),
                              Text(widget.model.flatNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Şehir",
                              ),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Ülke",
                              ),
                              Text(widget.model.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                msg: "Posta Kodu",
                              ),
                              Text(widget.model.pincode),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(
                    message: "İleriye",
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                addressId: widget.adressId,
                                totalAmount: widget.totalAmount,
                              ));
                      Navigator.push(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;
  const KeyText({
    Key key,
    this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
