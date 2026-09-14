class AddPaymentMethodBody {
  late String name;
  late String methodType;
  late String apiKey;
  late String apiSecret;
  late String methodMode;

  AddPaymentMethodBody(
      {required this.name,
      required this.methodType,
      required this.apiKey,
      required this.apiSecret,
      required this.methodMode});

  AddPaymentMethodBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    methodType = json['type'];
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
    methodMode = json['payment_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = methodType;
    data['api_key'] = apiKey;
    data['api_secret'] = apiSecret;
    data['payment_mode'] = methodMode;
    return data;
  }
}
