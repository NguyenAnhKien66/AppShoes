import 'package:flutter/material.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart';
import 'package:shoesapp/Component/ItemFavorite.dart'; 
import 'package:shoesapp/Data/Favorites_reader.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';
import 'package:shoesapp/Screens/AccountScreen.dart';
import 'package:shoesapp/Screens/CartScreen.dart';
import 'package:shoesapp/Screens/HomeScreen.dart';
import 'package:shoesapp/Screens/NotificationScreen.dart'; 
import 'package:shoesapp/Screens/ProductCategoryScreen.dart'; 

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int _selectedIndex = 1; 
  late Favorites _favorites; // Khai báo đối tượng Favorites
  List<String> _favoriteProductIds = []; // Danh sách ID sản phẩm yêu thích

  @override
  void initState() {
    super.initState();
    String userId = SharedPrefsManager.getUserId();
    _favorites = Favorites(userId); // Khởi tạo đối tượng Favorites
    _loadFavoriteProductIds(); // Tải danh sách ID sản phẩm yêu thích
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        break;
      case 1:
        // Already on FavoritesScreen
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

  Future<void> _loadFavoriteProductIds() async {
    try {
      _favoriteProductIds = await _favorites.loadListFavorites(); 
      setState(() {}); 
    } catch (e) {
      print('Error loading favorite product IDs: $e');
    }
  }

  Future<List<products>> _loadFavoriteProducts() async {
    return await products.loadProductsByIds(_favoriteProductIds); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text("Danh sách yêu thích"),
        ),
        automaticallyImplyLeading: false,
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
      
      body: FutureBuilder<List<products>>(
        future: _loadFavoriteProducts(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          } else {
            List<products> favoriteProducts = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                products product = favoriteProducts[index];
                return ItemFavorite(product: product, favorites: _favorites); 
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
