// ignore_for_file: no_leading_underscores_for_local_identifiers

class CustomerDetailsModel {
  Customer? customer;
  double totalInvoiceAmount;
  double totalPaidAmount;
  double totalDueAmount;
  double totalEstimateAmount;

  CustomerDetailsModel({
    this.customer,
    required this.totalInvoiceAmount,
    required this.totalPaidAmount,
    required this.totalDueAmount,
    required this.totalEstimateAmount,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    double _parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CustomerDetailsModel(
      customer: json['customer_details'] != null
          ? Customer.fromJson(json['customer_details'])
          : null,
      totalInvoiceAmount:
      _parseDouble(json['total_invoice_amount']),
      totalPaidAmount:
      _parseDouble(json['total_paid_amount']),
      totalDueAmount:
      _parseDouble(json['total_due_amount']),
      totalEstimateAmount:
      _parseDouble(json['total_estimate_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_details': customer?.toJson(),
      'total_invoice_amount': totalInvoiceAmount,
      'total_paid_amount': totalPaidAmount,
      'total_due_amount': totalDueAmount,
      'total_estimate_amount': totalEstimateAmount,
    };
  }
}
class Customer {
  int? id;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? gender;
  String? address;
  String? taxNo;
  String? status;
  String? profilePicture;

  Customer({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.gender,
    this.address,
    this.taxNo,
    this.status,
    this.profilePicture,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    address = json['address'];
    taxNo = json['tax_no'];
    status = json['status'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
      'tax_no': taxNo,
      'status': status,
      'profile_picture': profilePicture,
    };
  }
}
