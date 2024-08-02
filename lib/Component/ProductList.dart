import 'package:flutter/material.dart';
import 'package:shoesapp/Component/PriceText.dart';
import 'package:shoesapp/Component/Product_Image.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Screens/DetailScreen.dart';
import 'package:diacritic/diacritic.dart';

class ProductList extends StatelessWidget {
  final String sex;
  final Map<String, dynamic> filters;
  final String? searchTerm;

  ProductList({required this.sex, required this.filters, this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<products>>(
      future: products.loadProducts(
        sex: sex,
        minPrice: filters['minPrice'] ?? 0.0,
        maxPrice: filters['maxPrice'] ?? double.infinity,
        sizes: filters['sizes'] ?? [],
        categories: filters['categories'] ?? [],
        sortOption: filters['sortOption'] ?? 'Giá tăng dần',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải sản phẩm: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không tìm thấy sản phẩm.'));
        } else {
          List<products> productsList = snapshot.data!;

          // Apply search filter
          if (searchTerm != null && searchTerm!.isNotEmpty) {
            String normalizedSearchTerm = removeDiacritics(searchTerm!).toLowerCase();

            productsList = productsList.where((product) {
              String normalizedProductName = removeDiacritics(product.Name).toLowerCase();
              return normalizedProductName.contains(normalizedSearchTerm);
            }).toList();
          }

          return ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              final product = productsList[index];
              String imageUrl = product.Image;
              String discount = product.Discount;

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
                          child: product_image(currentImage: imageUrl, discount: discount),
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
                              PriceText(price: product.Price, discount: discount)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
