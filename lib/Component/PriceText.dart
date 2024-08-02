import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final String price;
  final String discount;
  const PriceText({super.key, required this.price, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(

        children: [
          if (double.parse(discount) > 0)
            TextSpan(
              text: '\$${double.parse(price).toStringAsFixed(2)} ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            WidgetSpan(
              child: SizedBox(width: 10), 
            ),
          if (double.parse(discount) > 0)
            TextSpan(
              text: '\$${(double.parse(price) - (double.parse(price)*(double.parse(discount)/100.0))).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            TextSpan(
              text: '\$${double.parse(price).toStringAsFixed(2)} ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}