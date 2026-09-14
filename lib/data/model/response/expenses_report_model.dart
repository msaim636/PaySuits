class ExpensesReportModel {
  int? id;
  String? title;
  String? date;
  String? amount;

  ExpensesReportModel({this.id, this.title, this.date, this.amount});

  ExpensesReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['amount'] = amount;
    return data;
  }
}
