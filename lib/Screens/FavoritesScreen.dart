import 'package:flutter/material.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart'; 
import 'package:shoesapp/Component/ItemFavorites.dart';
import 'package:shoesapp/Data/Products_reader.dart';
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
  late Future<List<products>> _favoriteProducts;
  int _selectedIndex = 1; 

  @override
  void initState() {
    super.initState();
    _favoriteProducts = products.loadFavoriteProducts();
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
            builder: (context) => HomeScreen( userId: "userId"), // Adjust parameters as needed
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
      case 4:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AccountScreen(),
        //   ),
        // );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(userId: 'A',),
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
                  builder: (context) => CartScreen(userId: "A"),
                ),
              );
            },
          ),
        ],
      ),
      
      body: FutureBuilder<List<products>>(
        future: _favoriteProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          } else {
            List<products> favoriteProducts = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                products product = favoriteProducts[index];
                return itemFavorite(product: product);
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
