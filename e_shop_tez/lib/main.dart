import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop_tez/Admin/adminLogin.dart';
import 'package:e_shop_tez/Counters/ItemQuantity.dart';
import 'package:e_shop_tez/Store/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication_login.dart';
import 'package:e_shop_tez/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
        title: 'e-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  bool a = false;
  displaySplash() {
    Timer(Duration(seconds: 2), () async {
      if (a) {
        Route route = MaterialPageRoute(builder: (_) => AdminSignInScreen());
        Navigator.pushReplacement(context, route);
      } else if (await EcommerceApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => HomePage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange[900],
                Colors.orange[800],
                Colors.orange[400]
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/welcome.png"),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Mobil Alış Veriş Uygulaman",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
