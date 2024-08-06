import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  final String invoiceId;
  final String userId;
  final List<dynamic> items;
  final String address;
  final String paymentMethod;
  final String voucher;
  final bool status;
  final String time;
  final String shippingCost;
  final String totalAmountDue;
  final bool move;
  final bool finished;
  final bool cancel;
  final bool reInvoices;

  Invoice({
    required this.invoiceId,
    required this.userId,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.voucher,
    required this.status,
    required this.time,
    required this.shippingCost,
    required this.totalAmountDue,
    required this.move,
    required this.finished,
    required this.cancel,
    required this.reInvoices
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      invoiceId: map['invoiceId'] ?? "",
      userId: map['userId'] ?? "",
      items: map['items'] ?? [],
      address: map['address'] ?? "",
      paymentMethod: map['paymentMethod'] ?? "",
      voucher: map['voucher'] ?? "",
      status: map['Status'] ?? false,
      time: map['time'] ?? "",
      shippingCost: map['shippingCost'].toString(),
      totalAmountDue: map['totalAmountDue'].toString(),
      move: map['move'],
      finished: map['finished'], 
      cancel:map['cancel'], reInvoices: map['reInvoices'] ,

    );
  }

  static Future<List<Invoice>> loadInvoices({
  required String userId,
  required bool status,
  bool move = false,
  bool finished = false,
  bool cancel = false,
  bool reInvoices = false
}) async {
  // Khởi tạo truy vấn cơ bản
  Query query = FirebaseFirestore.instance.collection('Invoices')
      .where('userId', isEqualTo: userId);

  // Áp dụng các điều kiện lọc
  if (cancel) {
    query = query.where('cancel', isEqualTo: true);
  } else if (reInvoices) {
    query = query.where('reInvoices', isEqualTo: true);
  } else {
    query = query
        .where('Status', isEqualTo: status)
        .where('move', isEqualTo: move)
        .where('finished', isEqualTo: finished)
        .where('cancel', isEqualTo: false)
        .where('reInvoices', isEqualTo: false);
  }

  // Truy vấn dữ liệu
  QuerySnapshot querySnapshot = await query.get();
  print("Found ${querySnapshot.docs.length} documents.");

  // Cập nhật tài liệu nếu cần
  if (cancel) {
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'Status': false,
        'move': false,
        'finished': false,
        'reInvoices': false
      });
    }
  }

  if (reInvoices) {
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'Status': false,
        'move': false,
        'finished': false,
        'cancel': false
      });
    }
  }

  // Chuyển đổi tài liệu thành đối tượng Invoice
  return querySnapshot.docs
      .map((doc) {
        print(doc.data());
        return Invoice.fromMap(doc.data() as Map<String, dynamic>);
      })
      .toList();
}


}
