// lib/widgets/product_info.dart
import 'package:flutter/material.dart';

class product_info extends StatelessWidget {
  final String quantity;
  

  product_info({required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          double.parse(quantity) > 0
              ? 'Tình trạng: Còn hàng \nSố lượng còn: $quantity'
              : 'Tình trạng: hết hàng',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        
        
      ],
    );
  }
}
