import 'package:flutter/material.dart';

class size_selector extends StatelessWidget {
  final String selectedSize;
  final Function(String) onSizeSelected;

  size_selector({required this.selectedSize, required this.onSizeSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15.0, // Khoảng cách giữa các nút
      runSpacing: 10.0, // Khoảng cách giữa các hàng
      children: [
        _sizeButton('39'),
        _sizeButton('40'),
        _sizeButton('41'),
        _sizeButton('42'),
        _sizeButton('43'),
        _sizeButton('44'),
        _sizeButton('45'),
      ],
    );
  }

  Widget _sizeButton(String size) {
    return Container(
      width: 80, // Đặt độ rộng cho nút
      child: ElevatedButton(
        onPressed: () => onSizeSelected(size),
        child: Text(size),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedSize == size ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
