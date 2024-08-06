import 'package:flutter/material.dart';

class QualityProductCart extends StatefulWidget {
  final int initialQuantity;
  final int maxQuantity;
  final void Function(int) onQuantityChanged; 

  const QualityProductCart({
    super.key,
    required this.initialQuantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
  });

  @override
  _QualityProductCartState createState() => _QualityProductCartState();
}

class _QualityProductCartState extends State<QualityProductCart> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
        widget.onQuantityChanged(_quantity); 
      });
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        widget.onQuantityChanged(_quantity); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _decrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(0),
            minimumSize: Size(20, 20),
          ),
          child: const Icon(Icons.remove, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 5),
        Text(
          '$_quantity',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: _increment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(0),
            minimumSize: Size(20, 20),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 16),
        ),
      ],
    );
  }
}
