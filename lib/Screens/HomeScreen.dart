import 'package:flutter/material.dart';
import 'package:shoesapp/Component/BackToTopButton.dart';
import 'package:shoesapp/Component/PanelHome.dart';
import 'package:shoesapp/Component/HorizontalProductList.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/AccountScreen.dart';
import 'package:shoesapp/Screens/CartScreen.dart';
import 'package:shoesapp/Screens/FavoritesScreen.dart';
import 'package:shoesapp/Screens/NotificationScreen.dart';
import 'package:shoesapp/Screens/ProductCategoryScreen.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart';
import 'package:shoesapp/Screens/SearchScreen.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(userId: userId),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  'Search for products...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_sharp, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
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
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
