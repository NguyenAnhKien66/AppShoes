import 'package:flutter/material.dart';
import 'package:shoesapp/Component/PriceText.dart';
import 'package:shoesapp/Component/Product_Image.dart';
import 'package:shoesapp/Data/Favorites_reader.dart';

import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Screens/DetailScreen.dart';

class ItemFavorite extends StatelessWidget {
  final products product;
  final Favorites favorites;

  const ItemFavorite({
    Key? key,
    required this.product,
    required this.favorites,
  }) : super(key: key);

  void _toggleFavorite() async {
    if (await favorites.isFavorite(product.Id)) {
      await favorites.removeFromFavorites(product.Id);
    } else {
      await favorites.addToFavorites(product.Id);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detail_screen(product: product),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomLeft: Radius.circular(4.0),
                          ),
                          child: product_image(currentImage: product.Image, discount: product.Discount),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.Name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              PriceText(price: product.Price, discount: product.Discount),
                              
                            
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
    
  }
}
