import 'package:flutter/material.dart';
import 'package:shoesapp/Component/Product_Image.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Screens/DetailScreen.dart';

class itemFavorite extends StatelessWidget {
  final products product;
  const itemFavorite({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => detail_screen(product: product),
          ),
        );
      },
      child: Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: product_image(currentImage: product.Image,
                        discount: product.Discount,)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.Name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${product.Price}\$',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                )
    );
  }
}