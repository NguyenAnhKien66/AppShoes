import 'package:flutter/material.dart';

class ButtonSize extends StatefulWidget {
  final int maxQuantity;

  const ButtonSize({
    Key? key,
    required this.maxQuantity,
  }) : super(key: key);

  @override
  ButtonSizeState createState() => ButtonSizeState();
}

class ButtonSizeState extends State<ButtonSize> {
  int _quantity = 1;

  int get quantity => _quantity; // Thêm getter cho quantity

  void _increment() {
    if (_quantity < widget.maxQuantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void resetQuantity() {
    setState(() {
      _quantity = 1; // Reset to default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Chọn số lượng: ", style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold)),
          // Sử dụng Expanded hoặc Flexible để điều chỉnh kích thước
          Expanded(
            child: ElevatedButton(
              onPressed: _decrement,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02), // Điều chỉnh kích thước nút
              ),
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$_quantity',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _increment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02), // Điều chỉnh kích thước nút
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
