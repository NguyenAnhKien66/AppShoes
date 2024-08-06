import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> item;

  ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(item['name'] ?? 'Product'),
        children: [
          ListTile(
           
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(item['imageUrl']),
                Text('giá: ${item['price'] ?? 'N/A'}'),
                Text('kích thước: ${item['size'] ?? 'N/A'}'),
                Text('Số lượng: ${item['quantity'] ?? 'N/A'}'),
                Text('Giới tính: ${item['Sex'] ?? 'N/A'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
