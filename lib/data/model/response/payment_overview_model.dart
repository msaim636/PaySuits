class IncomeStatics {
  String? totalAmount;
  String? totalPaidAmount;
  String? totalDueAmount;
  String? totalExpenseAmount;

  IncomeStatics({
    this.totalAmount,
    this.totalPaidAmount,
    this.totalDueAmount,
    this.totalExpenseAmount,
  });

  IncomeStatics.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    totalPaidAmount = json['total_paid_amount'];
    totalDueAmount = json['total_due_amount'];
    totalExpenseAmount = json['total_expense_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_amount'] = totalAmount;
    data['total_paid_amount'] = totalPaidAmount;
    data['total_due_amount'] = totalDueAmount;
    data['total_expense_amount'] = totalExpenseAmount;
    return data;
  }
}
