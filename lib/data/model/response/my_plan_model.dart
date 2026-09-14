class MyPlanModel {
  int? id;
  String? startDate;
  String? endDate;
  String? status;
  Plan? plan;
  BillingHistory? billingHistory;

  MyPlanModel({
    this.id,
    this.startDate,
    this.endDate,
    this.status,
    this.plan,
    this.billingHistory,
  });

  MyPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    billingHistory = json['billing_history'] != null
        ? BillingHistory.fromJson(json['billing_history'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    if (billingHistory != null) {
      data['billing_history'] = billingHistory!.toJson();
    }
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  double? price; // double preferred for numeric price
  String? formattedPrice;

  Plan({this.id, this.name, this.price, this.formattedPrice});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // Handle int or String from API
    final priceValue = json['price'];
    if (priceValue != null) {
      price = priceValue is int
          ? priceValue.toDouble()
          : double.tryParse(priceValue.toString());
    }
    formattedPrice = json['formatted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['formatted_price'] = formattedPrice;
    return data;
  }
}

class BillingHistory {
  int? id;
  String? paymentMethod;
  String? amount;
  String? formattedAmount;
  BillingHistory({
    this.id,
    this.paymentMethod,
    this.amount,
    this.formattedAmount,
  });
  BillingHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    formattedAmount = json['formatted_amount'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['formatted_amount'] = formattedAmount;
    return data;
  }
}
