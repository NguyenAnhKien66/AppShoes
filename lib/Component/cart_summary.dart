import 'package:flutter/material.dart';

class CartSummaryWidget extends StatelessWidget {
  final bool allSelected;
  final void Function(bool?)? onSelectAllChanged;
  final double totalPrice;
  final void Function()? onPayment;

  const CartSummaryWidget({
    Key? key,
    required this.allSelected,
    this.onSelectAllChanged,
    required this.totalPrice,
    this.onPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: onSelectAllChanged,
          ),
          const Text('Select All'),
          const Spacer(),
          Text(
            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: onPayment,
          ),
        ],
      ),
    );
  }
}