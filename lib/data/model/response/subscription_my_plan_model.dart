class SubscriptionMyPlanModel {
  int? id;
  String? name;
  String? tag;
  String? frequency;
  String? price;
  String? isFree;
  int? trialDays;
  bool? isDefault;
  String? numberOfProducts;
  String? numberOfCustomers;
  String? numberOfEstimates;
  String? numberOfInvoices;
  PlanFeatures? planFeatures;

  SubscriptionMyPlanModel({
    this.id,
    this.name,
    this.tag,
    this.frequency,
    this.price,
    this.isFree,
    this.trialDays,
    this.isDefault,
    this.numberOfProducts,
    this.numberOfCustomers,
    this.numberOfEstimates,
    this.numberOfInvoices,
    this.planFeatures,
  });

  SubscriptionMyPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tag = json['tag'];
    frequency = json['frequency'];
    price = json['price'];
    isFree = json['is_free'];
    trialDays = json['trial_days'];
    isDefault = json['is_default'];
    numberOfProducts = json['number_of_products'];
    numberOfCustomers = json['number_of_customers'];
    numberOfEstimates = json['number_of_estimates'];
    numberOfInvoices = json['number_of_invoices'];
    planFeatures = json['plan_features'] != null
        ? PlanFeatures.fromJson(json['plan_features'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tag'] = tag;
    data['frequency'] = frequency;
    data['price'] = price;
    data['is_free'] = isFree;
    data['trial_days'] = trialDays;
    data['is_default'] = isDefault;
    data['number_of_products'] = numberOfProducts;
    data['number_of_customers'] = numberOfCustomers;
    data['number_of_estimates'] = numberOfEstimates;
    data['number_of_invoices'] = numberOfInvoices;
    if (planFeatures != null) {
      data['plan_features'] = planFeatures!.toJson();
    }
    return data;
  }
}

class PlanFeatures {
  bool? global;
  bool? dashboard;
  bool? customers;
  bool? invoices;
  bool? estimates;
  bool? transactions;
  bool? productCategories;
  bool? productUnits;
  bool? products;
  bool? expenseCategories;
  bool? expenses;
  bool? reports;
  bool? taxes;
  bool? notes;
  bool? paymentMethods;
  bool? customizations;
  bool? users;
  bool? roles;
  bool? exports;
  bool? tickets;
  bool? settings;

  PlanFeatures({
    this.global,
    this.dashboard,
    this.customers,
    this.invoices,
    this.estimates,
    this.transactions,
    this.productCategories,
    this.productUnits,
    this.products,
    this.expenseCategories,
    this.expenses,
    this.reports,
    this.taxes,
    this.notes,
    this.paymentMethods,
    this.customizations,
    this.users,
    this.roles,
    this.exports,
    this.tickets,
    this.settings,
  });
  PlanFeatures.fromJson(Map<String, dynamic> json) {
    global = json['global'];
    dashboard = json['dashboard'];
    customers = json['customers'];
    invoices = json['invoices'];
    estimates = json['estimates'];
    transactions = json['transactions'];
    productCategories = json['product_categories'];
    productUnits = json['product_units'];
    products = json['products'];
    expenseCategories = json['expense_categories'];
    expenses = json['expenses'];
    reports = json['reports'];
    taxes = json['taxes'];
    notes = json['notes'];
    paymentMethods = json['payment_methods'];
    customizations = json['customizations'];
    users = json['users'];
    roles = json['roles'];
    exports = json['exports'];
    tickets = json['tickets'];
    settings = json['settings'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['global'] = global;
    data['dashboard'] = dashboard;
    data['customers'] = customers;
    data['invoices'] = invoices;
    data['estimates'] = estimates;
    data['transactions'] = transactions;
    data['product_categories'] = productCategories;
    data['product_units'] = productUnits;
    data['products'] = products;
    data['expense_categories'] = expenseCategories;
    data['expenses'] = expenses;
    data['reports'] = reports;
    data['taxes'] = taxes;
    data['notes'] = notes;
    data['payment_methods'] = paymentMethods;
    data['customizations'] = customizations;
    data['users'] = users;
    data['roles'] = roles;
    data['exports'] = exports;
    data['tickets'] = tickets;
    data['settings'] = settings;
    return data;
  }
}
