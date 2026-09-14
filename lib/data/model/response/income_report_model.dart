class IncomeReportModel {
  int? id;
  String? customerName;
  String? issueDate;
  String? receivedAmount;

  IncomeReportModel({this.id, this.issueDate, this.receivedAmount});

  IncomeReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerName = json['customer_name'];
    issueDate = json['issue_date'];
    receivedAmount = json['received_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_name'] = customerName;
    data['issue_date'] = issueDate;
    data['received_amount'] = receivedAmount;
    return data;
  }
}
