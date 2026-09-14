class CustomerModel {
  int? id;
  String? fullName;
  String? email;
  String? status;
  String? profilePictureUrl;

  CustomerModel({
    this.id,
    this.fullName,
    this.email,
    this.status,
    this.profilePictureUrl,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    status = json['status'];
    profilePictureUrl = json['profile_picture_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    data['status'] = status;
    data['profile_picture_url'] = profilePictureUrl;
    return data;
  }
}
