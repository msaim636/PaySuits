class BillingModel {
  int? id;
  Tenant? tenant;
  Plan? plan;
  PaymentMethod? paymentMethod;
  String? invoiceNumber;
  String? amount;
  String? createdAt;
  String? status;

  BillingModel({
    this.id,
    this.tenant,
    this.plan,
    this.paymentMethod,
    this.amount,
    this.status,
  });

  BillingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenant = json['tenant'] != null ? Tenant.fromJson(json['tenant']) : null;
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    invoiceNumber = json['invoice_number'];
    amount = json['amount'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (tenant != null) {
      data['tenant'] = tenant!.toJson();
    }
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
    data['invoice_number'] = invoiceNumber;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['status'] = status;
    return data;
  }
}

class Tenant {
  int? id;
  String? name;

  Tenant({this.name, this.id});

  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  String? isFree;

  Plan({this.name, this.id, this.isFree});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isFree = json['is_free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_free'] = isFree;
    return data;
  }
}

class PaymentMethod {
  int? id;
  String? name;

  PaymentMethod({this.id, this.name});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
