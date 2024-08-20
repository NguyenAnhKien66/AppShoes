import 'package:flutter/material.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart';
import 'package:shoesapp/Component/DialogFillter.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/AccountScreen.dart';
import 'package:shoesapp/Screens/CartScreen.dart';
import 'package:shoesapp/Screens/DetailScreen.dart';
import 'package:shoesapp/Screens/FavoritesScreen.dart';
import 'package:shoesapp/Screens/HomeScreen.dart';
import 'package:shoesapp/Screens/NotificationScreen.dart';
import 'package:shoesapp/Screens/SearchScreen.dart';
import 'package:shoesapp/Screens/productCategoryScreen.dart';

class ControllerPage extends StatefulWidget {
  final String? searchTerm;

  ControllerPage({this.searchTerm});

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int _selectedIndex = 0;
  Map<String, dynamic> _filters = {};
  String Iduser = SharedPrefsManager.getUserId();

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreen(),
      FavoriteScreen(),
      ProductCategoryScreen(searchTerm: widget.searchTerm),
      NotificationScreen(),
      AccountScreen(),
    ]);
    
    if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
      _selectedIndex = 2; // Set to ProductCategoryScreen
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _selectedIndex == 2
            ? AppBar(
                backgroundColor: Colors.blueAccent,
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
                          builder: (context) => SearchScreen(userId: Iduser),
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
              )
            : ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0)),
                child: AppBar(
                  backgroundColor: Colors.blueAccent,
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
                            builder: (context) => SearchScreen(userId: Iduser),
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
              ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
