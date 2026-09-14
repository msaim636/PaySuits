class InvoiceModel {
  int? id;
  String? customerName;
  String? invoiceNumber;
  String? issueDate;
  String? dueDate;
  String? totalAmount;
  String? paidAmount;
  String? dueAmount;
  String? status;

  InvoiceModel({
    this.id,
    this.customerName,
    this.invoiceNumber,
    this.issueDate,
    this.dueDate,
    this.totalAmount,
    this.paidAmount,
    this.dueAmount,
    this.status,
  });

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    invoiceNumber = json['invoice_number'];
    issueDate = json['issue_date'];
    dueDate = json['due_date'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    dueAmount = json['due_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['invoice_number'] = invoiceNumber;
    data['issue_date'] = issueDate;
    data['due_date'] = dueDate;
    data['total_amount'] = totalAmount;
    data['paid_amount'] = paidAmount;
    data['due_amount'] = dueAmount;
    data['status'] = status;
    return data;
  }
}

