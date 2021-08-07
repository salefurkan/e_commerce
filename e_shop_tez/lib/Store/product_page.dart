import 'package:flutter/material.dart';

import 'package:e_shop_tez/Models/item.dart';
import 'package:e_shop_tez/Store/storehome.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  const ProductPage({
    Key key,
    this.itemModel,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              width: screenSize.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 400.0,
                        child: Center(
                          child: Image.network(widget.itemModel.thumbnailUrl),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            widget.itemModel.price.toString() + "₺",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.redAccent[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          checkItemInCart(widget.itemModel.shortInfo, context);
                        },
                        child: Container(
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
                          width: screenSize.width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Sepetine Ekle",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
