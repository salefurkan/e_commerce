import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Config/config.dart';
import 'package:e_shop_tez/Address/address.dart';
import 'package:e_shop_tez/Widgets/loadingWidget.dart';
import 'package:e_shop_tez/Models/item.dart';
import 'package:e_shop_tez/Counters/cartitemcounter.dart';
import 'package:e_shop_tez/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop_tez/Store/storehome.dart';
import 'package:provider/provider.dart';

class FavPage extends StatefulWidget {
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  double totalAmount;
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "FAVORİLER",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userFavList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingFavCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);
                              return sourceInfo(model, context,
                                  removeCartFunction: () =>
                                      removeItemFromUserFavCart(
                                          model.shortInfo /*,context*/),
                                  ctrl: true);
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  removeItemFromUserFavCart(String shortInfoAsId /*,BuildContext context*/) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userFavList);
    tempCartList.remove(shortInfoAsId);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userFavList: tempCartList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Ürün favorilerinizden çıkarıldı");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userFavList, tempCartList);
      /*Provider.of<CartItemCounter>(context, listen: false).displayResult();*/
      totalAmount = 0;
    });
  }

  beginbuildingFavCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Favori listeniz boş"),
              Text("Favorilerinize ürün eklemeye başlayın"),
            ],
          ),
        ),
      ),
    );
  }
}
