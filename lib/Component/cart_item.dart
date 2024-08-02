import 'package:flutter/material.dart';
import 'package:shoesapp/Data/carts_reader.dart';
import 'package:shoesapp/Component/QualityProductCart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final int maxQuantity;
  final void Function(bool?)? onSelectionChanged;
  final void Function()? onRemove;
  final void Function(int) onQuantityChanged;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.maxQuantity,
    this.onSelectionChanged,
    this.onRemove,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: item.isSelected,
            onChanged: onSelectionChanged,
          ),
          SizedBox(
            width: 80,
            height: 100,
            child: Image.network(item.imageUrl, fit: BoxFit.fill),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('Size: ${item.size}', style: const TextStyle(fontSize: 13)),
                Text('Price: \$${double.parse(item.price) * item.quantity}', style: const TextStyle(fontSize: 13)),
                QualityProductCart(
                  initialQuantity: item.quantity,
                  maxQuantity: maxQuantity,
                  onQuantityChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}