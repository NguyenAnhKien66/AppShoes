import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesapp/Component/CustomBottomNav.dart';
import 'package:shoesapp/Data/Invoices_reader.dart';
import 'package:shoesapp/Screens/FavoritesScreen.dart';
import 'package:shoesapp/Screens/HomeScreen.dart';
import 'package:shoesapp/Screens/productCategoryScreen.dart';

class NotificationScreen extends StatefulWidget {
  final String userId;

  const NotificationScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<Invoice>> _invoices;
  int _selectedIndex = 3; 
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: "userId"), 
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductCategoryScreen(),
          ),
        );
        break;
      case 4:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AccountScreen(),
        //   ),
        // );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(userId: 'A',),
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _invoices = _loadInvoices();
  }

  Future<List<Invoice>> _loadInvoices() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('Invoices')
        .where('userId', isEqualTo: widget.userId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Invoice.fromMap(data..['id'] = doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text("Thông báo"),
        )
      ),
      body: FutureBuilder<List<Invoice>>(
        future: _invoices,
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
                  title: invoice.status==true?Text('Đơn hàng ${invoice.invoiceId} của bạn đã được xác nhận từ cửa hàng'):Text('Đơn hàng ${invoice.invoiceId} của bạn đang chờ xác nhận từ cửa hàng'),
                  subtitle: Text(
                    'Price: \$${invoice.totalAmountDue} \nNgày: ${invoice.time}',
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => InvoiceDetailScreen(invoiceId: invoice.id),
                    //   ),
                    // );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
