class SuggestedTaxesModel {
  int? id;
  String? name;
  dynamic rate;

  SuggestedTaxesModel({this.id, this.name, this.rate});

  SuggestedTaxesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rate'] = rate;
    return data;
  }
}
