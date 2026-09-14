class CompanySettingsModel {
  final String? companyName;
  final String? companyAddress;
  final String? companyPhone;
  final String? companyEmail;
  final String? currencySymbol;
  final String? dateFormat;
  final String? decimalSeparator;
  final String? thousandSeparator;
  final int? numberOfDecimal;
  final String? currencyPosition;
  final String? companyLogo;
  final String? companyTaxId;
  final String? companyWebsite;

  CompanySettingsModel({
    this.companyName,
    this.companyAddress,
    this.companyPhone,
    this.companyEmail,
    this.currencySymbol,
    this.dateFormat,
    this.decimalSeparator,
    this.thousandSeparator,
    this.numberOfDecimal,
    this.currencyPosition,
    this.companyLogo,
    this.companyTaxId,
    this.companyWebsite,
  });

  factory CompanySettingsModel.fromJson(Map<String, dynamic> json) {
    return CompanySettingsModel(
      companyName: json['company_name'],
      companyAddress: json['company_address'],
      companyPhone: json['company_phone'],
      companyEmail: json['company_email'],
      currencySymbol: json['currency_symbol'],
      dateFormat: json['date_format'],
      decimalSeparator: json['decimal_separator'],
      thousandSeparator: json['thousand_separator'],
      numberOfDecimal: json['number_of_decimal'] != null
          ? int.tryParse(json['number_of_decimal'].toString())
          : null,
      currencyPosition: json['currency_position'],
      companyLogo: json['company_logo'],
      companyTaxId: json['company_tax_id'],
      companyWebsite: json['company_website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'company_address': companyAddress,
      'company_phone': companyPhone,
      'company_email': companyEmail,
      'currency_symbol': currencySymbol,
      'date_format': dateFormat,
      'decimal_separator': decimalSeparator,
      'thousand_separator': thousandSeparator,
      'number_of_decimal': numberOfDecimal,
      'currency_position': currencyPosition,
      'company_logo': companyLogo,
      'company_tax_id': companyTaxId,
      'company_website': companyWebsite,
    };
  }
}
