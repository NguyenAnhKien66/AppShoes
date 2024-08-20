import 'package:flutter/material.dart';
import 'package:shoesapp/Component/ItemFavorite.dart'; 
import 'package:shoesapp/Data/Favorites_reader.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  
  late Favorites _favorites; 
  List<String> _favoriteProductIds = []; 

  @override
  void initState() {
    super.initState();
    String userId = SharedPrefsManager.getUserId();
    _favorites = Favorites(userId); 
    _loadFavoriteProductIds(); 
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
     
    );
  }
}
