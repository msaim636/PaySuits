class UsersModel {
  int? id;
  String? fullName;
  String? email;
  bool? isAdmin;
  Status? status;
  String? roleName;
  bool? isSubscriber;
  String? profilePictures;

  UsersModel({
    this.id,
    this.fullName,
    this.email,
    this.isAdmin,
    this.status,
    this.roleName,
    this.isSubscriber,
    this.profilePictures,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    isAdmin = json['is_admin'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    roleName = json['role_name'];
    isSubscriber = json['is_subscriber'];
    profilePictures = json['profile_pictures'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['is_admin'] = isAdmin;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['role_name'] = roleName;
    data['is_subscriber'] = isSubscriber;
    data['profile_pictures'] = profilePictures;
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? className;
  String? translatedName;

  Status({this.id, this.name, this.className, this.translatedName});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    className = json['class'];
    translatedName = json['translated_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['class'] = className;
    data['translated_name'] = translatedName;
    return data;
  }
}
