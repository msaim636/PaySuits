class PaymentOverviewModel {
  double receivedAmount;
  double dueAmount;

  PaymentOverviewModel({
    required this.receivedAmount,
    required this.dueAmount,
  });

  factory PaymentOverviewModel.fromJson(Map<String, dynamic> json) {
    return PaymentOverviewModel(
      receivedAmount: (json['received_amount'] ?? 0).toDouble(),
      dueAmount: (json['due_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'received_amount': receivedAmount,
      'due_amount': dueAmount,
    };
  }
}
