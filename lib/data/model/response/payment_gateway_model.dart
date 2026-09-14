class PaymentGatewayModel {
  int? id;
  String? name;
  String? type;
  String? apiKey;
  String? apiSecret;

  PaymentGatewayModel({this.id, this.name,this.type,this.apiKey,this.apiSecret});

  PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['api_key'] = apiKey;
    data['api_secret'] = apiSecret;
    return data;
  }


}