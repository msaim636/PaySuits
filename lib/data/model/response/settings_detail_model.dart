class SettingsDetailModel {
  String? prefix;
  String? serialStart;
  String? logo;

  SettingsDetailModel({this.prefix, this.serialStart, this.logo});

  SettingsDetailModel.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    serialStart = json['serial_start'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    data['serial_start'] = serialStart;
    data['logo'] = logo;
    return data;
  }
}
