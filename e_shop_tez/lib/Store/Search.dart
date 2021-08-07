import 'package:e_shop_tez/Models/item.dart';
import 'package:e_shop_tez/Store/storehome.dart';
import 'package:e_shop_tez/Widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  void initState() {
    setState(() {
      startSearching(" ");
    });
    super.initState();
  }

  Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model = ItemModel.fromJson(
                          snapshot.data.documents[index].data);
                      return sourceInfo(model, context);
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: 90.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [Colors.orange[900], Colors.orange[800], Colors.orange[400]],
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.blueGrey),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (val) {
                    startSearching(val);
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Hemen ara.."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = Firestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}
