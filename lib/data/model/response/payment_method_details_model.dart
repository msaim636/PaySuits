class PaymentMethodDetailsModel {
  int? id;
  String? name;
  String? type;
  List<Settings>? settings;

  PaymentMethodDetailsModel({this.id, this.name, this.type, this.settings});

  PaymentMethodDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    if (json['settings'] != null) {
      settings = <Settings>[];
      json['settings'].forEach((v) {
        settings!.add(Settings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    if (settings != null) {
      data['settings'] = settings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Settings {
  String? apiKey;
  String? apiSecret;

  Settings({this.apiKey, this.apiSecret});

  Settings.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api_key'] = apiKey;
    data['api_secret'] = apiSecret;
    return data;
  }
}
