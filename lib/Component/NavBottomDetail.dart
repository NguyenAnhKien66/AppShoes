import 'package:flutter/material.dart';

import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/carts_reader.dart'; // Đảm bảo rằng bạn đã import CartService

class nav_bottom_detail extends StatefulWidget {
  final VoidCallback onAddToFavorites;
  final VoidCallback onAddToCart;
  final bool isFavorite; // Trạng thái yêu thích
  final CartService cartService; // Dịch vụ giỏ hàng để thêm sản phẩm vào giỏ hàng
  final products product; // Thông tin sản phẩm để thêm vào giỏ hàng

  const nav_bottom_detail({
    super.key,
    required this.onAddToFavorites,
    required this.onAddToCart,
    required this.isFavorite, // Khởi tạo trạng thái yêu thích
    required this.cartService,
    required this.product,
  });

  @override
  _nav_bottom_detailState createState() => _nav_bottom_detailState();
}

class _nav_bottom_detailState extends State<nav_bottom_detail> {
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.8;
    double buttonHeight = MediaQuery.of(context).size.height * 0.07;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              widget.onAddToFavorites();
              setState(() {}); // Cập nhật giao diện sau khi nhấn nút
            },
            icon: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.isFavorite ? Colors.red : null,
            ),
          ),
          ElevatedButton(
            onPressed: () {
               // Gọi hàm thêm sản phẩm vào giỏ hàng
              widget.onAddToCart(); // Gọi hàm thêm vào giỏ hàng từ widget cha
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: Size(buttonWidth, buttonHeight),
            ),
            child: Container(
              child: const Row(
                children: [
                  Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'Thêm vào giỏ hàng',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
