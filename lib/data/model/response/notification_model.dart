class NotificationModel {
  String? id;
  NotificationData? data;
  String? readAt;
  String? createdAt;

  NotificationModel({
    this.id,
    this.data,
    this.readAt,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null
        ? NotificationData.fromJson(json['data'])
        : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
  }
}


class NotificationData {
  String? title;
  String? message;

  NotificationData({this.title, this.message});

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['message'] = message;
    return data;
  }
}
