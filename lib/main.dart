import 'package:flutter/material.dart';
import 'registration.dart';
import 'authorization.dart';
import 'home.dart';
import 'package:backmoney/shop_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
      ),
      routes: {
        '/' : (context) => HomePage(),
        '/shop_view' : (context) => ShopView(),
        '/authorization' : (context) => AuthorizationPage(),
        '/registration' : (context) => RegistrationPage(),
      },
    );
  }
}