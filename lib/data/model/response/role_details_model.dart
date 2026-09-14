// ignore_for_file: unnecessary_new

class RoleDetailModel {
  int? id;
  String? name;
  List<Permissions>? permissions;

  RoleDetailModel({this.id, this.name, this.permissions});

  RoleDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  int? id;
  String? name;
  String? groupName;
  String? translatedName;

  Permissions({this.id, this.name, this.groupName, this.translatedName});

  Permissions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupName = json['group_name'];
    translatedName = json['translated_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['group_name'] = groupName;
    data['translated_name'] = translatedName;
    return data;
  }
}
