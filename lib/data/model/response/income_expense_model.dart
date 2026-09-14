class IncomeExpenseChartModel {
  List<IncomeData>? income;
  List<ExpenseData>? expense;

  IncomeExpenseChartModel({this.income, this.expense});

  IncomeExpenseChartModel.fromJson(Map<String, dynamic> json) {
    if (json['income'] != null) {
      income = <IncomeData>[];
      json['income'].forEach((v) {
        income!.add(IncomeData.fromJson(v));
      });
    }
    if (json['expense'] != null) {
      expense = <ExpenseData>[];
      json['expense'].forEach((v) {
        expense!.add(ExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (income != null) {
      data['income'] = income!.map((v) => v.toJson()).toList();
    }
    if (expense != null) {
      data['expense'] = expense!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IncomeData {
  double? income;
  String? context;
  String? date;

  IncomeData({this.income, this.context, this.date});

  IncomeData.fromJson(Map<String, dynamic> json) {
    income = (json['income'] as num?)?.toDouble();
    context = json['context'];
    date = json['date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['income'] = income;
    data['context'] = context;
    data['date'] = date;
    return data;
  }
}

class ExpenseData {
  double? expense;
  String? context;
  String? date;

  ExpenseData({this.expense, this.context, this.date});

  ExpenseData.fromJson(Map<String, dynamic> json) {
    expense = (json['expense'] as num?)?.toDouble();
    context = json['context'];
    date = json['date'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expense'] = expense;
    data['context'] = context;
    data['date'] = date;
    return data;
  }
}
