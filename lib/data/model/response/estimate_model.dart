class EstimateModel {
  int? id;
  String? customerName;
  String? invoiceFullNumber;
  String? date;
  String? total;
  String? status;

  EstimateModel({
    this.id,
    this.customerName,
    this.invoiceFullNumber,
    this.date,
    this.total,
    this.status,
  });

  EstimateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    invoiceFullNumber = json['invoice_number'];
    date = json['date'];
    total = json['total'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['invoice_number'] = invoiceFullNumber;
    data['date'] = date;
    data['total'] = total;
    data['status'] = status;
    return data;
  }
}