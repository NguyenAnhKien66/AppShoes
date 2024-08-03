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
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      invoiceId: map['invoiceId']?? "",
      userId: map['userId']?? "",
      items: map['items']?? "",
      address: map['address']?? "",
      paymentMethod: map['paymentMethod'],
      voucher: map['voucher']?? "",
      status: map['Status']?? false,
      time: map['time']?? "",
      shippingCost: map['shippingCost'].toString(),
      totalAmountDue: map['totalAmountDue'].toString(),
    );
  }
}
