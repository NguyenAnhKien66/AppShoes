import 'package:flutter/material.dart';

class ButtomAddtoCart extends StatefulWidget {
  final VoidCallback onAddToCart;
  const ButtomAddtoCart({super.key, required this.onAddToCart});

  @override
  State<ButtomAddtoCart> createState() => _ButtomAddtoCartState();
}

class _ButtomAddtoCartState extends State<ButtomAddtoCart> {
  bool isExpend = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpend = !isExpend;
          widget.onAddToCart();
        });
        if (isExpend) {
          Future.delayed(Duration(milliseconds: 1500), () {
            setState(() {
              isExpend = false;
            });
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: 40,
        width: isExpend ? 250 : 180,
        decoration: BoxDecoration(
          color: isExpend ? Colors.amber : Colors.blueAccent,
          borderRadius: BorderRadius.circular(isExpend ? 50 : 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isExpend ? Icons.check : Icons.shopping_cart,
              size: 30,
              color: Colors.white,
            ),
            if (isExpend)
              const Text(
                'Add to cart',
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
