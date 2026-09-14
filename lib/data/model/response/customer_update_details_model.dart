class CustomerUpdateDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? phoneCountry;
  String? companyName;

  String? taxNo;
  String? gender;
  String? address;
  bool? portalAccess;

  CustomerUpdateDetailsModel({
    this.id,
    this.companyName,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountry,
    this.taxNo,
    this.gender,
    this.address,
    this.portalAccess,
  });

  CustomerUpdateDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    phoneCountry = json['phone_country'];
    taxNo = json['tax_no'];
    gender = json['gender'];
    address = json['address'];
    portalAccess = json['portal_access'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['phone_country'] = phoneCountry;
    data['tax_no'] = taxNo;
    data['gender'] = gender;
    data['address'] = address;
    data['portal_access'] = portalAccess;
    return data;
  }
}
