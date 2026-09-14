class RolesModel {
  int? id;
  String? name;
  int? userCount;
  List<String>? userProfilePictures;

  RolesModel({this.id, this.name, this.userCount, this.userProfilePictures});

  RolesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userCount = json['user_count'];
    // Check if 'user_profile_pictures' is not null before casting
    if (json['user_profile_pictures'] != null) {
      userProfilePictures = List<String>.from(json['user_profile_pictures']);
    } else {
      userProfilePictures = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_count'] = userCount;
    data['user_profile_pictures'] = userProfilePictures;
    return data;
  }
}
