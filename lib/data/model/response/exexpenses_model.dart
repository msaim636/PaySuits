class ExpensesModel {
  int? id;
  String? title;
  String? date;
  String? amount;
  String? categoryName;

  ExpensesModel(
      {this.id, this.title, this.date, this.amount, this.categoryName});

  ExpensesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    amount = json['amount'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['amount'] = amount;
    data['category_name'] = categoryName;
    return data;
  }
}
