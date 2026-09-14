class AddCustomerBody {
  late String companyName;
  late String firstName;
  late String lastName;
  late String email;
  late String phoneCountry;
  late String phone;
  late String taxNo;
  late String address;
  late String gender;
  late String portalAccess;

  AddCustomerBody(
      {required this.companyName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneCountry,
      required this.phone,
      required this.taxNo,
      required this.address,
      required this.gender,
      required this.portalAccess});

  AddCustomerBody.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneCountry = json['phone_country'];
    phone = json['phone_number'];
    taxNo = json['tax_no'];
    address = json['address'];
    gender = json['gender'];
    portalAccess = json['portal_access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_country'] = phoneCountry;
    data['phone_number'] = phone;
    data['tax_no'] = taxNo;
    data['address'] = address;
    data['gender'] = gender;
    data['portal_access'] = portalAccess;
    return data;
  }
}
