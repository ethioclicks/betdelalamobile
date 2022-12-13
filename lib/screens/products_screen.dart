import 'package:betdelalamobile/widget/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../widget/product_grid.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedIndex = 0;
  void initState() {
    _pages = [
      {
        'page': ProductGrid(),
      },
      {
        'page': TabScreen(),
      },
       {
        'page': ProductGrid(),
      },
       {
        'page': TabScreen(),
      },

    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex]['page'] as Widget,
      bottomNavigationBar: GNav(
          tabMargin: EdgeInsets.fromLTRB(10, 5, 15, 0),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey.shade300,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.black,
          tabBorderRadius: 70.00,
          iconSize: 30,
          gap: 10.0,
          padding: const EdgeInsets.all(12),
          onTabChange: _selectPage,
          //curve: Curves.easeInCirc,
          // ignore: prefer_const_literals_to_create_immutables
          tabs: [
            const GButton(
              icon: Icons.home, // text: 'Home'
            ),
            const GButton(
              icon: Icons.search,
              //text: 'search',
            ),
            const GButton(
              icon: Icons.favorite,
              //text: 'favourite',
            ),
            const GButton(
              icon: Icons.account_circle,
              //text: 'account',
            )
          ]),
    );
  }
}
