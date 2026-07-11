class PaymentItem {
  const PaymentItem({
    required this.id,
    required this.memberName,
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
  });

  final String id;
  final String memberName;
  final double amount;
  final PaymentMethod paymentMethod;
  final DateTime paidAt;
}

enum PaymentMethod { cash, upi, bankTransfer }
