//import 'package:betdelalamobile/providers/products_screen.dart';
// @dart=2.9
import './screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductScreen(),
      routes: {
       // DetailScreen.routename: ((context) => DetailScreen()),
      },
    );
  }
}
