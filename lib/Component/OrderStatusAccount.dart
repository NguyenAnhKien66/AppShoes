import 'package:flutter/material.dart';
import 'package:shoesapp/Screens/OrdersPage.dart';

class OrderStatusAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Đơn hàng của tôi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage(initialTabIndex: 0)),
                );
              },
              child: Text('Xem tất cả'),
            ),
          ],
        ),
        Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildOrderStatusButton(
                context,
                title: 'Chờ xác nhận',
                icon: Icons.access_time,
                tabIndex: 0,
              ),
              _buildOrderStatusButton(
                context,
                title: 'Đang xử lý',
                icon: Icons.assignment,
                tabIndex: 1,
              ),
              _buildOrderStatusButton(
                context,
                title: 'Đang vận chuyển',
                icon: Icons.local_shipping,
                tabIndex: 2,
              ),
              _buildOrderStatusButton(
                context,
                title: 'Đánh giá',
                icon: Icons.rate_review,
                tabIndex: 3,
              ),
              _buildOrderStatusButton(
                context,
                title: 'Đã hủy',
                icon: Icons.cancel,
                tabIndex: 4,
              ),
              _buildOrderStatusButton(
                context,
                title: 'Trả hàng',
                icon: Icons.undo,
                tabIndex: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusButton(BuildContext context, {required String title, required IconData icon, required int tabIndex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(onPressed: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersPage(initialTabIndex: tabIndex)),
          );
        }, icon: Icon(icon)),
        Text(title,)
        ]
      )
    );
  }
}
