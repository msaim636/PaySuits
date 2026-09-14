// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class CustomerListModel {
  int? id;
  String? fullName;

  CustomerListModel({this.id, this.fullName});

  CustomerListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    return data;
  }
}
