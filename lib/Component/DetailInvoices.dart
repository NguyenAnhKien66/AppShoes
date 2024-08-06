import 'package:flutter/material.dart';
import 'package:shoesapp/Component/InvoicesCard.dart';
import 'package:shoesapp/Data/Invoices_reader.dart';

class InvoiceDetailPage extends StatelessWidget {
  final Invoice invoice;

  InvoiceDetailPage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết hóa đơn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('ID Hóa đơn: ${invoice.invoiceId}'),
            Text('Địa Chỉ: ${invoice.address}'),
            Text('Phương Thức Thanh Toán: ${invoice.paymentMethod}'),
            Text('Voucher: ${invoice.voucher}'),
            Text('Ngày mua: ${invoice.time}'),
            Text('Phí vận chuyển: ${invoice.shippingCost}'),
            Text('Tổng tiền: ${invoice.totalAmountDue}'),
            SizedBox(height: 20),
            Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...invoice.items.map((item) => ProductCard(item: item)).toList(),
          ],
        ),
      ),
    );
  }
}

