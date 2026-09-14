class TicketUpdateModel {
  int? id;
  String? subject;
  int? departmentId;
  int? priorityId;
  List<Images>? images;

  TicketUpdateModel({
    this.id,
    this.subject,
    this.departmentId,
    this.priorityId,
    this.images,
  });

  TicketUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json["subject"];
    departmentId = json["department_id"];
    priorityId = json["priority_id"];

    if (json['images'] != null && json['images'] is List) {
      images = (json['images'] as List).map((e) => Images.fromJson(e)).toList();
    } else {
      images = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["subject"] = subject;
    data["department_id"] = departmentId;
    data["priority_id"] = priorityId;
    data['images'] = images?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Images {
  int? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
