import 'package:flutter/material.dart';
import 'package:shoesapp/Component/PriceText.dart';
import 'package:shoesapp/Component/Product_Image.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Screens/DetailScreen.dart';

class item_home extends StatelessWidget {
  final products product;
  const item_home({super.key, required this.product});

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
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                SizedBox(
                  height: 150,
                  child: product.Image.isNotEmpty
                      ? product_image(currentImage: product.Image, discount: product.Discount)
                      : const Icon(Icons.image, size: 100),
                ),
                // Product Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.Name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.Description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Product Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: PriceText(price: product.Price, discount: product.Discount)
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
