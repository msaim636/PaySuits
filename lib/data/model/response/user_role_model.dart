class UserRolesModel {
  int? id;
  String? name;
  bool? isAdmin;
  bool? isDefault;

  UserRolesModel({this.id, this.name, this.isAdmin, this.isDefault});

  UserRolesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isAdmin = json['is_admin'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_admin'] = isAdmin;
    data['is_default'] = isDefault;
    return data;
  }
}
