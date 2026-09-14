class TransactionResult {
  GrandTotal? grandTotal;
  List<CustomerTransactionModel>? data;

  TransactionResult({this.grandTotal, this.data});

  TransactionResult.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null
        ? GrandTotal.fromJson(json['grand_total'])
        : null;

    if (json['data'] != null) {
      data = <CustomerTransactionModel>[];
      json['data'].forEach((v) {
        data!.add(CustomerTransactionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (grandTotal != null) {
      data['grand_total'] = grandTotal!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrandTotal {
  String? grandTotal;

  GrandTotal({this.grandTotal});

  GrandTotal.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {'grand_total': grandTotal};
  }
}

class CustomerTransactionModel {
  int? id;
  String? transactionInvoiceNumber;
  String? receivedOn;
  String? amount;
  String? paymentMethod;
  String? refInvoiceNumber;
  String? status;

  CustomerTransactionModel({
    this.id,
    this.transactionInvoiceNumber,
    this.receivedOn,
    this.amount,
    this.paymentMethod,
    this.refInvoiceNumber,
  });

  CustomerTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionInvoiceNumber = json['transaction_invoice_number'];
    receivedOn = json['received_on'];
    amount = json['amount'];
    paymentMethod = json['payment_method'];
    refInvoiceNumber = json['ref_invoice_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_invoice_number'] = transactionInvoiceNumber;
    data['received_on'] = receivedOn;
    data['amount'] = amount;
    data['payment_method'] = paymentMethod;
    data['ref_invoice_number'] = refInvoiceNumber;
    return data;
  }
}
