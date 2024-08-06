import 'package:flutter/material.dart';

import 'package:shoesapp/Component/orderList.dart';
import 'package:shoesapp/Data/shared_prefs_manager.dart';

class OrdersPage extends StatelessWidget {
  final int initialTabIndex;

  OrdersPage({required this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    final userId = SharedPrefsManager.getUserId();
    return DefaultTabController(
      length: 6,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đơn hàng của tôi'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang xử lý'),
              Tab(text: 'Đang vận chuyển'),
              Tab(text: 'Nhận hàng đã giao'),
              Tab(text: 'Đã hủy'),
              Tab(text: 'Trả hàng'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InvoiceList(
              userId: userId,
              status: false,
              move: false,
              finished: false,
              cancel: false, reInvoices: false,
            ),
            InvoiceList(
              userId: userId,
              status: true,
              move: false,
              finished: false,
              cancel: false, reInvoices: false,
            ),
            InvoiceList(
              userId: userId,
              status: true,
              move: true,
              finished: false,
              cancel: false,
              reInvoices: false,
            ),
            InvoiceList(
              userId: userId,
              status: true,
              move: true,
              finished: true,
              cancel: false,
              reInvoices: false,
            ),
            InvoiceList(
              userId: userId,
              status: false,
              move: false,
              finished: false,
              cancel: true,
              reInvoices: false,
            ),
            InvoiceList(
              userId: userId,
              status: false,
              move: false,
              finished: false,
              cancel: false,
              reInvoices: true,
            ),
          ],
        ),
      ),
    );
  }
}
