class DuePaymentBody {
  late String receivedOn;
  late String payingAmount;
  late dynamic paymentMethod;
  late String note;

  DuePaymentBody(
      {required this.receivedOn,
      required this.payingAmount,
      required this.paymentMethod,
      required this.note});

  DuePaymentBody.fromJson(Map<String, dynamic> json) {
    receivedOn = json['received_on'];
    payingAmount = json['paying_amount'];
    paymentMethod = json['payment_method_id'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['received_on'] = receivedOn;
    data['paying_amount'] = payingAmount;
    data['payment_method_id'] = paymentMethod;
    data['note'] = note;
    return data;
  }
}
