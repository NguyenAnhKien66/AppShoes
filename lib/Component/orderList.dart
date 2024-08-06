import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/Component/DetailInvoices.dart';
import 'package:shoesapp/Data/Invoices_reader.dart';

class InvoiceList extends StatefulWidget {
  final String userId;
  final bool status;
  final bool move;
  final bool finished;
  final bool cancel;
  final bool reInvoices;

  InvoiceList({
    required this.userId,
    required this.status,
    required this.move,
    required this.finished,
    required this.cancel,
    required this.reInvoices,
  });

  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  late Future<List<Invoice>> _invoiceFuture;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  void _loadInvoices() {
    setState(() {
      _invoiceFuture = Invoice.loadInvoices(
        userId: widget.userId,
        status: widget.status,
        move: widget.move,
        finished: widget.finished,
        cancel: widget.cancel,
        reInvoices: widget.reInvoices,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Invoice>>(
      future: _invoiceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có dữ liệu'));
        } else {
          List<Invoice> invoices = snapshot.data!;
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              Invoice invoice = invoices[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text('Mã hóa đơn: ${invoice.invoiceId}'),
                      subtitle: Text('Tổng: ${invoice.totalAmountDue}'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceDetailPage(invoice: invoice),
                          ),
                        );
                      },
                    ),
                    if (!widget.cancel && !widget.finished && !widget.reInvoices)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleCancelOrder(context, invoice.invoiceId);
                          },
                          child: Text('Hủy Đơn Hàng'),
                        ),
                      ),
                    if (widget.finished)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleReturnOrder(context, invoice.invoiceId);
                          },
                          child: Text('Trả Đơn Hàng'),
                        ),
                      ),
                    if (widget.finished)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _handleRateProduct(context, invoice.invoiceId);
                          },
                          child: Text('Đánh Giá Sản Phẩm'),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _handleCancelOrder(BuildContext context, String invoiceId) async {
    try {
      await FirebaseFirestore.instance.collection('Invoices').doc(invoiceId).update({
        'cancel': true,
        'Status': false,
        'move': false,
        'finished': false,
        'reInvoices': false,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hủy đơn hàng thành công')),
      );
      _loadInvoices(); // Tải lại dữ liệu
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleReturnOrder(BuildContext context, String invoiceId) async {
    try {
      await FirebaseFirestore.instance.collection('Invoices').doc(invoiceId).update({
        'reInvoices': true,
        'Status': false,
        'move': false,
        'finished': false,
        'cancel': false,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trả đơn hàng thành công')),
      );
      _loadInvoices(); // Tải lại dữ liệu
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  void _handleRateProduct(BuildContext context, String invoiceId) {
    print('Rate Product: $invoiceId');
  }
}
