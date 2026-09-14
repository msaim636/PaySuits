class TransactionModel {
  int? id;
  String? customerName;
  String? receivedOn;
  String? invoiceFullNumber;
  String? transactionFullNumber;
  String? paymentMethod;
  String? amount;
  String? note;
  String? profilePicture;

  TransactionModel(
      {this.id,
      this.customerName,
      this.receivedOn,
      this.invoiceFullNumber,
      this.transactionFullNumber,
      this.paymentMethod,
      this.amount,
      this.note,
      this.profilePicture});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    receivedOn = json['received_on'];
    invoiceFullNumber = json['invoice_full_number'];
    transactionFullNumber = json['transaction_full_number'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    note = json['note'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['received_on'] = receivedOn;
    data['invoice_full_number'] = invoiceFullNumber;
    data['transaction_full_number'] = transactionFullNumber;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['note'] = note;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
