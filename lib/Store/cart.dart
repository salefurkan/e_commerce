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

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Sepetiniz Boş");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));
            Navigator.push(context, route);
          }
        },
        label: Text("Sepeti Onayla"),
        icon: Icon(
          Icons.payment,
          color: Colors.white54,
        ),
      ),
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
                            "Toplam Ücret: " +
                                amountProvider.totalAmount.toString() +
                                "₺",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
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
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price + totalAmount;
                              } else {
                                totalAmount = model.price + totalAmount;
                              }
                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .display(totalAmount);
                                });
                              }
                              return sourceInfo(model, context,
                                  removeCartFunction: () =>
                                      removeItemFromUserCart(
                                          model.shortInfo /*,context*/
                                          ));
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

  removeItemFromUserCart(String shortInfoAsId /*,BuildContext context*/) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempCartList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Ürün sepetinizden çıkarıldı");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      /*Provider.of<CartItemCounter>(context, listen: false).displayResult();*/
      totalAmount = 0;
    });
  }

  beginbuildingCart() {
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
              Text("Sepetiniz boş"),
              Text("Sepetinize ürün eklemeye başlayın"),
            ],
          ),
        ),
      ),
    );
  }
}
