import 'package:flutter/material.dart';
import 'package:shoesapp/Component/cart_item.dart';
import 'package:shoesapp/Component/cart_summary.dart';
import 'package:shoesapp/Data/carts_reader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesapp/Screens/PaymentScreen.dart';

class CartScreen extends StatefulWidget {
  final String userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartService _cartService;
  late Future<List<CartItem>> _cartItemsFuture;
  List<CartItem> _cartItems = [];
  List<CartItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    
    _cartService = CartService(widget.userId);
    _cartItemsFuture = _cartService.getCartItems();
    _cartItemsFuture.then((items) {
      setState(() {
        _cartItems = items;
        _selectedItems = items.where((item) => item.isSelected).toList();
      });
    });
  }
  void _navigateToPaymentScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          selectedItems: _selectedItems,
          userId: widget.userId,
        ),
      ),
    );

    if (result == true) {
      // Nếu thanh toán thành công, làm mới dữ liệu giỏ hàng  
      _loadCartItems();
    }
  }
  Future<void> _loadCartItems() async {
    final items = await _cartService.getCartItems();
    setState(() {
      _cartItems = items;
      _selectedItems = items.where((item) => item.isSelected).toList();
      _cartItemsFuture = Future.value(items);
    });
  }

  void _toggleSelection(CartItem item) {
    setState(() {
      item.isSelected = !item.isSelected;
      if (item.isSelected) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }
    });
  }

  void _removeItem(CartItem item) async {
    try {
      await _cartService.removeItemFromCart(item.id);
      _loadCartItems();
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _cartItems.forEach((item) {
        item.isSelected = value ?? false;
        if (item.isSelected) {
          _selectedItems.add(item);
        } else {
          _selectedItems.remove(item);
        }
      });
    });
  }

  Future<int> _getMaxQuantity(String productId, String size) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance.collection('Products').doc(productId).get();
      Map<String, dynamic> data = productDoc.data() as Map<String, dynamic>;
      int maxQuantity = int.parse(data['Size$size'] ?? '0');
      return maxQuantity;
    } catch (e) {
      print('Error loading product data: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          } else {
            final cartItems = snapshot.data!;
            final allSelected = _cartItems.every((item) => item.isSelected);
            final totalPrice = _selectedItems.fold(0.0, (sum, item) => sum + double.parse(item.price) * item.quantity);
            
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return FutureBuilder<int>(
                        future: _getMaxQuantity(item.productId, item.size),
                        builder: (context, maxQuantitySnapshot) {
                          if (maxQuantitySnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final maxQuantity = maxQuantitySnapshot.data ?? 0;
                          return CartItemWidget(
                            item: item,
                            maxQuantity: maxQuantity,
                            onSelectionChanged: (value) => _toggleSelection(item),
                            onRemove: () => _removeItem(item),
                            onQuantityChanged: (newQuantity) => setState(() => item.quantity = newQuantity),
                          );
                        },
                      );
                    },
                  ),
                ),
                CartSummaryWidget(
                  allSelected: allSelected,
                  onSelectAllChanged: _toggleSelectAll,
                  totalPrice: totalPrice,
                  onPayment: () {
                     _navigateToPaymentScreen(); 
                                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
