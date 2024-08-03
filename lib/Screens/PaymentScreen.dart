import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shoesapp/Data/Products_reader.dart';
import 'package:shoesapp/Data/carts_reader.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> selectedItems;
  final String userId;

  const PaymentScreen({super.key, required this.selectedItems, required this.userId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _addressController = TextEditingController();
  bool _isBankTransfer = false;
  bool _isCash = false;
  String _voucher = '';
  double _shippingCost = 10.0; 
  late CartService _cartService;
  bool status =false;
  

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.selectedItems.fold(0.0, (sum, item) => sum + double.parse(item.price) * item.quantity);
    final voucherDiscount = 0.0; 
    final totalAmountDue = totalPrice + _shippingCost - voucherDiscount;
    _cartService = CartService(widget.userId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
         title: const Center(
          child: Text("Thanh toán"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
                return ListTile(
                  leading: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(item.imageUrl, fit: BoxFit.cover),
                  ),
                  title: Text(item.name),
                  subtitle: Text('Size: ${item.size} - Quantity: ${item.quantity} - Price: \$${item.price}'),
                );
              },
            ),
          ),
          // Address
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Payment 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                  value: _isBankTransfer,
                  onChanged: (value) {
                    setState(() {
                      _isBankTransfer = value ?? false;
                      if (_isBankTransfer) _isCash = false;
                    });
                  },
                ),
                const Text('Bank Transfer'),
                Checkbox(
                  value: _isCash,
                  onChanged: (value) {
                    setState(() {
                      _isCash = value ?? false;
                      if (_isCash) _isBankTransfer = false;
                    });
                  },
                ),
                const Text('Cash'),
              ],
            ),
          ),
          // Voucher 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _voucher = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Voucher Code',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Payment Details 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                Text('Shipping Cost: \$${_shippingCost.toStringAsFixed(2)}'),
                Text('Voucher Discount: \$${voucherDiscount.toStringAsFixed(2)}'),
                Text('Total Amount Due: \$${totalAmountDue.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _handlePayment();

            },
            child: const Text('Pay Now'),
          ),
        ),
      ),
    );
  }



  void _handlePayment() async {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy h:mm:ss a');
  final String formattedTime = dateFormat.format(DateTime.now());
  final invoiceData = {
    'invoiceId':"",
    'userId': widget.userId,
    'items': widget.selectedItems.map((item) => {
      'idProduct':item.productId,
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'size': item.size,
      'imageUrl': item.imageUrl,
      'Sex':item.sex,
    }).toList(),
    'address': _addressController.text,
    'paymentMethod': _isBankTransfer ? 'Bank Transfer' : 'Cash',
    'voucher': _voucher,
    'Status': status,
    'time': formattedTime,
    
    'shippingCost': (_shippingCost).toString(),
    'totalAmountDue': (widget.selectedItems.fold(0.0, (sum, item) => sum + double.parse(item.price) * item.quantity) + _shippingCost - 0.0).toString(),
  };

  final firestore = FirebaseFirestore.instance;

  try {
  // Add invoice to 'Invoices' collection and get document reference
      DocumentReference invoiceRef = await firestore.collection('Invoices').add(invoiceData);

      // Get the document ID
      final invoiceId = invoiceRef.id;

      // Optionally, you can update the document with additional information if needed
      await invoiceRef.update({'invoiceId': invoiceId});

      // Reduce the quantity of each product in the inventory
      for (var item in widget.selectedItems) {
        await products.updateQuantityProduct(item.productId, item.size, item.quantity);
        await _cartService.removeItemFromCart(item.id);
      }

      // Navigate back after successful payment and stock update
      Navigator.pop(context, true);
    } catch (e) {
      print('Error handling payment: $e');
    }

  }
}
