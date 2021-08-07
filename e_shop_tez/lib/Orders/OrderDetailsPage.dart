import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Address/address.dart';
import 'package:e_shop_tez/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:e_shop_tez/Config/config.dart';
import 'package:e_shop_tez/Models/address.dart';
import 'package:e_shop_tez/Widgets/loadingWidget.dart';
import 'package:e_shop_tez/Widgets/orderCard.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;
  const OrderDetails({
    Key key,
    this.orderID,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    getOrderId = orderID;
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
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
                .get(),
            builder: (context, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dataMap[EcommerceApp.totalAmount].toString() +
                                    "₺",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              "Sipariş Tarihi: " +
                                  DateFormat.yMMMMEEEEd('tr_TR').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? OrderCard(
                                      itemCount: snapshot.data.documents.length,
                                      data: snapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;
  const StatusBanner({
    Key key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Başarılı" : msg = "Başarısız";
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Colors.orange[900],
            Colors.orange[800],
            Colors.orange[400],
          ],
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Sipariş Durumu: " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;
  const ShippingDetails({
    Key key,
    this.model,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Alışveriş Detayları",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(
                    msg: "Ad",
                  ),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Telefon Numarası",
                  ),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Daire Numarası",
                  ),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Şehir",
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Ülke",
                  ),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Posta Kodu",
                  ),
                  Text(model.pincode),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(
            10.0,
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmedUserOrderReceived(context, getOrderId);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.orange[900],
                      Colors.orange[800],
                      Colors.orange[400],
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Satın alma onayı",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();
    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.push(context, route);

    Fluttertoast.showToast(msg: "Onayınız için teşekkürler.");
  }
}
