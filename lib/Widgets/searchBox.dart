import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Stack(
        children: [
          Positioned(
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
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              child: InkWell(
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (_) => SearchProduct());
                  Navigator.push(context, route);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Ürün ara",
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
