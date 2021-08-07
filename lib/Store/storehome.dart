import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:e_shop_tez/Store/product_page.dart';
import 'package:e_shop_tez/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop_tez/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchBoxDelegate(),
            floating: false,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("items")
                .limit(15)
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        ItemModel model = ItemModel.fromJson(
                            dataSnapshot.data.documents[index].data);
                        return sourceInfo(model, context, strCtrl: true);
                      },
                      itemCount: dataSnapshot.data.documents.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction, bool ctrl, bool strCtrl}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
          builder: (_) => ProductPage(
                itemModel: model,
              ));
      Navigator.push(context, route);
      print(model.title);
    },
    splashColor: Colors.orangeAccent,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 182.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              width: 140.0,
              height: 140.0,
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.deepOrangeAccent[200],
                        ),
                        alignment: Alignment.topLeft,
                        width: 80.0,
                        margin: EdgeInsets.only(right: 10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "%50",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "İndirim",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  r"Orjinal Fiyatı:",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15.0,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  "₺" + (model.price + model.price).toString(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  r"Yeni Fiyatı:",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "₺" + (model.price).toString(),
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      strCtrl == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: removeCartFunction == null
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        checkItemInFav(
                                            model.shortInfo, context);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.thumb_down,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        removeCartFunction();
                                        Route route = MaterialPageRoute(
                                            builder: (_) => HomePage());
                                        Navigator.pushReplacement(
                                            context, route);
                                      },
                                    ),
                            )
                          : Text(""),
                      ctrl == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: removeCartFunction == null
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        checkItemInFav(
                                            model.shortInfo, context);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.thumb_down,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        removeCartFunction();
                                        Route route = MaterialPageRoute(
                                            builder: (_) => HomePage());
                                        Navigator.pushReplacement(
                                            context, route);
                                      },
                                    ),
                            )
                          : Align(
                              alignment: Alignment.centerRight,
                              child: removeCartFunction == null
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.lightGreen,
                                      ),
                                      onPressed: () {
                                        checkItemInCart(
                                            model.shortInfo, context);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.remove_shopping_cart,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        removeCartFunction();
                                        Route route = MaterialPageRoute(
                                            builder: (_) => HomePage());
                                        Navigator.pushReplacement(
                                            context, route);
                                      },
                                    ),
                            ),
                      ctrl == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.lightGreen,
                                ),
                                onPressed: () {
                                  checkItemInCart(model.shortInfo, context);
                                },
                              ),
                            )
                          : Text(""),
                    ],
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.black87,
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

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150,
    width: width * 0.34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(0, 5),
          blurRadius: 10.0,
          color: Colors.grey[100],
        ),
      ],
    ),
    child: ClipRect(
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInFav(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userFavList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Ürün zaten favorilerinizde.")
      : addItemToFavList(shortInfoAsID, context);
}

addItemToFavList(String shortInfoAsID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userFavList);
  tempCartList.add(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
    EcommerceApp.userFavList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Ürün Favorilerinze eklendi");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userFavList, tempCartList);
  });
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Ürün zaten sepetinizde.")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
    EcommerceApp.userCartList: tempCartList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Ürün sepetinize eklendi");
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
