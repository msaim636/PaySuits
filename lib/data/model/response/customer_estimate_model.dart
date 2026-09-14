class EstimateResult {
  GrandTotal? grandTotal;
  List<CustomerEstimateModel>? data;

  EstimateResult({this.grandTotal, this.data});

  EstimateResult.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grand_total'] != null
        ? GrandTotal.fromJson(json['grand_total'])
        : null;

    if (json['data'] != null) {
      data = <CustomerEstimateModel>[];
      json['data'].forEach((v) {
        data!.add(CustomerEstimateModel.fromJson(v));
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

class CustomerEstimateModel {
  int? id;
  String? customerName;
  String? invoiceFullNumber;
  String? issueDate;
  String? dueDate;
  String? grandTotal;
  String? status;

  CustomerEstimateModel({
    this.id,
    this.customerName,
    this.invoiceFullNumber,
    this.issueDate,
    this.dueDate,
    this.grandTotal,
    this.status,
  });

  CustomerEstimateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    invoiceFullNumber = json['invoice_full_number'];
    issueDate = json['issue_date'];
    dueDate = json['due_date'];
    grandTotal = json['grand_total'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['invoice_number'] = invoiceFullNumber;
    data['issue_date'] = issueDate;
    data['due_date'] = dueDate;
    data['grand_total'] = grandTotal;
    data['status'] = status;
    return data;
  }
}