
import 'package:flutter/material.dart';

class product_image extends StatelessWidget {
  final String currentImage;
  final String discount;

  product_image({required this.currentImage, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        // Hiển thị hình ảnh chính
        Image.network(
          currentImage,
          height: MediaQuery.of(context).size.height/2,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Nếu có giảm giá, hiển thị nhãn giảm giá
        if (discount.isNotEmpty && int.tryParse(discount)! > 0)
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.red,
            child: Text(
              'SALE $discount%',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
