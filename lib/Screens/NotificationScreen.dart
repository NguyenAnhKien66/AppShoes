import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/Data/Invoices_reader.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Stream<List<Invoice>> _invoiceStream;
  
  String userId = SharedPrefsManager.getUserId();

  

  @override
  void initState() {
    super.initState();
    _invoiceStream = _loadInvoices();
  }

  Stream<List<Invoice>> _loadInvoices() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('Invoices')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Invoice.fromMap(data..['id'] = doc.id);
      }).toList();
    });
  }

  String _getNotificationMessage(Invoice invoice) {
    if (!invoice.status && !invoice.move && !invoice.finished && !invoice.cancel && !invoice.reInvoices) {
      return 'Đơn hàng ${invoice.invoiceId} của bạn đang chờ xác nhận từ cửa hàng';
    } else if (invoice.status && !invoice.move && !invoice.finished && !invoice.cancel && !invoice.reInvoices) {
      return 'Đơn hàng ${invoice.invoiceId} của bạn đã được xác nhận từ cửa hàng';
    } else if (invoice.status && invoice.move && !invoice.finished && !invoice.cancel && !invoice.reInvoices) {
      return 'Đơn hàng ${invoice.invoiceId} của bạn đang được giao';
    } else if (invoice.status && !invoice.move && invoice.finished && !invoice.cancel && !invoice.reInvoices) {
      return 'Đơn hàng ${invoice.invoiceId} của bạn đã gửi đến bạn';
    } else if (!invoice.status && !invoice.move && !invoice.finished && invoice.cancel && !invoice.reInvoices) {
      return 'Đơn ${invoice.invoiceId} đã bị hủy';
    } else if (!invoice.status && !invoice.move && !invoice.finished && !invoice.cancel && invoice.reInvoices) {
      return 'Đơn ${invoice.invoiceId} đã được trả';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder<List<Invoice>>(
        stream: _invoiceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications found.'));
          } else {
            final invoices = snapshot.data!;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text(_getNotificationMessage(invoice)),
                  subtitle: Text(
                    'Price: \$${invoice.totalAmountDue} \nNgày mua: ${invoice.time}',
                  ),
                  onTap: () {
                    // Handle tap if needed
                  },
                );
              },
            );
          }
        },
      ),
      
    );
  }
}
