import 'package:flutter/material.dart';
import 'package:shoesapp/Component/BackToTopButton.dart';
import 'package:shoesapp/Component/PanelHome.dart';
import 'package:shoesapp/Component/HorizontalProductList.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/AccountScreen.dart';

import 'package:shoesapp/Screens/FavoritesScreen.dart';
import 'package:shoesapp/Screens/NotificationScreen.dart';
import 'package:shoesapp/Screens/ProductCategoryScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userId = SharedPrefsManager.getUserId();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductCategoryScreen(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AccountScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      panel_home(),
                      horizontal_product_list(
                        title: "Best Sellers",
                        futureProducts: products.loadBestSellingProducts(),
                        onSeeAllPressed: () {
                          // Handle see all action for Best Sellers
                          print('See All Best Sellers');
                        },
                      ),
                      horizontal_product_list(
                        title: "Super Promotions",
                        futureProducts: products.loadSuperSaleProducts(),
                        onSeeAllPressed: () {
                          // Handle see all action for Super Promotions
                          print('See All Super Promotions');
                        },
                      ),
                      horizontal_product_list(
                        title: "New Products",
                        futureProducts: products.loadNewProducts(),
                        onSeeAllPressed: () {
                          // Handle see all action for New Products
                          print('See All New Products');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BackToTopButton(scrollController: _scrollController),
        ],
      ),
     
    );
  }
}
