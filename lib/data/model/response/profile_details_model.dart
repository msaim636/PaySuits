class ProfileDetailsModel {
  int? id;
  String? email;
  String? profilePicture;
  String? firstName;
  String? lastName;
  String? fullName;
  String? gender;
  String? phoneCountry;
  String? phoneNumber;
  String? address;
  bool? isSubscriber;

  ProfileDetailsModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.phoneCountry,
    this.address,
    this.gender,
    this.isSubscriber,
    this.profilePicture,
  });

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'] ?? "";
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    phoneCountry = json['phone_country'];
    address = json['address'];
    gender = json['gender'];
    isSubscriber = json['is_subscriber'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['phone_country'] = phoneCountry;
    data['address'] = address;
    data['gender'] = gender;
    data['is_subscriber'] = isSubscriber;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
