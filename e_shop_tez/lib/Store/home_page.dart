import 'package:e_shop_tez/Address/address.dart';
import 'package:e_shop_tez/Store/fav_product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:e_shop_tez/Address/addAddress.dart';
import 'package:e_shop_tez/Authentication/authenication_login.dart';
import 'package:e_shop_tez/Config/config.dart';
import 'package:e_shop_tez/Counters/cartitemcounter.dart';
import 'package:e_shop_tez/Orders/myOrders.dart';
import 'package:e_shop_tez/Store/Search.dart';
import 'package:e_shop_tez/Store/cart.dart';
import 'package:e_shop_tez/Store/storehome.dart';

import '../Models/item.dart';

double width;

class HomePage extends StatefulWidget {
  final int currentIndex;
  final ItemModel productItemModel;
  const HomePage({
    Key key,
    this.currentIndex,
    this.productItemModel,
  }) : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(/*this.productItemModel, this.currentIndex*/);
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  /*_HomePageState(ItemModel _productItemModel, int currentIndex) {
    pModel = _productItemModel;
    this._currentIndex = currentIndex;
  }*/
  /*@override
  void initState() {
    pModel = widget.productItemModel;
    _currentIndex = widget.currentIndex;
    super.initState();
  }*/

  //static ItemModel pModel;

  int _currentIndex = 0;
  List<dynamic> _children = [
    StoreHome(),
    CartPage(),
    FavPage(),
    MyOrders(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, size: 30.0),
                onPressed: () {
                  onTappedBar(1);
                },
              ),
              Positioned(
                child: Stack(
                  children: [
                    Icon(Icons.brightness_1, size: 20.0),
                    Positioned(
                      top: 3.0,
                      left: 6.0,
                      bottom: 4.0,
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                          return counter.count == 0
                              ? Text("")
                              : Text(
                                  (EcommerceApp.sharedPreferences
                                              .getStringList(
                                                  EcommerceApp.userCartList)
                                              .length -
                                          1)
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.orange[900],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.person, size: 30.0),
            onPressed: () {
              onBottonPressed();
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_rounded),
            label: "Sepet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: "Favoriler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: "Siparişlerim",
          ),
        ],
      ),
    );
  }

  void checkItemInCart(String productID, BuildContext context) {}

  void inBottonPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.orange[50],
        context: context,
        builder: (context) {
          return Container(
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Adreslerim'),
                  onTap: () {
                    Navigator.pop(context);
                    Route route = MaterialPageRoute(builder: (c) => Address());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.orange[100],
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(Icons.add_location_alt_outlined),
                  title: Text('Adres ekle'),
                  onTap: () {
                    Navigator.pop(context);
                    Route route =
                        MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                  },
                ),
              ],
            ),
          );
        });
  }

  void onBottonPressed() {
    showModalBottomSheet(
      backgroundColor: Colors.orange[50],
      context: context,
      builder: (context) {
        return Container(
          height: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Ana Sayfa'),
                onTap: () {
                  Navigator.pop(context);
                  onTappedBar(0);
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.orange[100],
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(Icons.format_list_bulleted),
                title: Text('Siparişlerim'),
                onTap: () {
                  Navigator.pop(context);
                  onTappedBar(3);
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.orange[100],
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text('Sepetim'),
                onTap: () {
                  Navigator.pop(context);
                  onTappedBar(1);
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.orange[100],
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text('Ürün Ara'),
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (c) => SearchProduct());
                  Navigator.pushReplacement(context, route);
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.orange[100],
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(Icons.location_searching_outlined),
                title: Text('Adres İşlemleri'),
                onTap: () {
                  Navigator.pop(context);
                  inBottonPressed();
                },
              ),
              Divider(
                height: 10.0,
                color: Colors.orange[100],
                thickness: 6.0,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Çıkış Yap'),
                onTap: () {
                  Navigator.pop(context);
                  EcommerceApp.auth.signOut().then((value) {
                    Fluttertoast.showToast(msg: "Başarıyla Çıkış Yapıldı");
                    Route route =
                        MaterialPageRoute(builder: (c) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}
