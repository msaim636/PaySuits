class TicketDetailsModel {
  String? subject;
  String? status;
  String? ticketNumber;
  String? createdAt;
  String? updatedAt;
  int? rating;
  SubmittedBy? submittedBy;
  List<Comments>? comments;

  TicketDetailsModel({
    this.subject,
    this.status,
    this.ticketNumber,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.submittedBy,
    this.comments,
  });
  TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    status = json['status'];
    ticketNumber = json['ticket_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rating = json['rating'];
    submittedBy = json['submitted_by'] != null
        ? SubmittedBy.fromJson(json['submitted_by'])
        : null;
    comments = json['comments'] != null
        ? List<Comments>.from(json['comments'].map((x) => Comments.fromJson(x)))
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['status'] = status;
    data['ticket_number'] = ticketNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['rating'] = rating;
    if (submittedBy != null) {
      data['submitted_by'] = submittedBy!.toJson();
    }
    if (comments != null) {
      data['comments'] = comments!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class SubmittedBy {
  int? id;
  String? email;
  String? fullName;

  SubmittedBy({this.id, this.email, this.fullName});
  SubmittedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['full_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['full_name'] = fullName;
    return data;
  }
}

class Comments {
  int? id;
  String? comment;
  String? userType;
  String? createdAt;

  Comments({this.id, this.comment, this.userType, this.createdAt});
  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userType = json['user_type'];
    createdAt = json['created_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_type'] = userType;
    data['created_at'] = createdAt;
    return data;
  }
}
