class InvoiceResult {
  GrandTotal? grandTotal;
  List<CustomerInvoiceDetilesModel>? data;

  InvoiceResult({this.grandTotal, this.data});

  InvoiceResult.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null
        ? GrandTotal.fromJson(json['grand_total'])
        : null;

    if (json['data'] != null) {
      data = <CustomerInvoiceDetilesModel>[];
      json['data'].forEach((v) {
        data!.add(CustomerInvoiceDetilesModel.fromJson(v));
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
  String? receivedAmount;
  String? dueAmount;
  String? partialPaid;

  GrandTotal({
    this.grandTotal,
    this.receivedAmount,
    this.dueAmount,
    this.partialPaid,
  });

  GrandTotal.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total']?.toString();
    receivedAmount = json['received_amount']?.toString();
    dueAmount = json['due_amount']?.toString();
    partialPaid = json['partial_paid']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'grand_total': grandTotal,
      'received_amount': receivedAmount,
      'due_amount': dueAmount,
      'partial_paid': partialPaid,
    };
  }
}

class CustomerInvoiceDetilesModel {
  int? id;
  String? invoiceNumber;
  String? issueDate;
  String? dueDate;
  String? totalAmount;
  String? receivedAmount;
  String? dueAmount;
  String? status;

  CustomerInvoiceDetilesModel({
    this.id,
    this.invoiceNumber,
    this.issueDate,
    this.dueDate,
    this.totalAmount,
    this.receivedAmount,
    this.dueAmount,
    this.status,
  });

  CustomerInvoiceDetilesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoice_full_number'];
    issueDate = json['issue_date'];
    dueDate = json['due_date'];
    totalAmount = json['grand_total'];
    receivedAmount = json['received_amount'];
    dueAmount = json['due_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_full_number': invoiceNumber,
      'issue_date': issueDate,
      'due_date': dueDate,
      'grand_total': totalAmount,
      'received_amount': receivedAmount,
      'due_amount': dueAmount,
      'status': status,
    };
  }
}
