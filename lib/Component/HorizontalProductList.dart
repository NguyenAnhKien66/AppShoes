import 'package:flutter/material.dart';
import 'package:shoesapp/Component/ItemHome.dart';
import 'package:shoesapp/Data/Products_reader.dart';

class horizontal_product_list extends StatelessWidget {
  final String title;
  final Future<List<products>> futureProducts;
  final VoidCallback onSeeAllPressed;

  const horizontal_product_list({
    super.key,
    required this.title,
    required this.futureProducts,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAllPressed,
                child: Text("See All"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300, // Height of the horizontal list view
          child: FutureBuilder<List<products>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products available'));
              } else {
                final products = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Container(
                      width: 200,
                      padding: EdgeInsets.all(8.0),
                      child: item_home(product: product),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
