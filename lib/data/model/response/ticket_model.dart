class TicketModel {
  int? id;
  String? subject;
  Priority? priority;
  Department? department;
  SubmittedBy? submittedBy;
  String? status;
  String? createdAt;
  String? updatedAt;

  TicketModel({
    this.id,
    this.subject,
    this.priority,
    this.department,
    this.submittedBy,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  TicketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    priority = json['priority'] != null
        ? Priority.fromJson(json['priority'])
        : null;
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    submittedBy = json['submitted_by'] != null
        ? SubmittedBy.fromJson(json['submitted_by'])
        : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    if (priority != null) {
      data['priority'] = priority!.toJson();
    }
    if (department != null) {
      data['department'] = department!.toJson();
    }
    if (submittedBy != null) {
      data['submitted_by'] = submittedBy!.toJson();
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Priority {
  int? id;
  String? name;

  Priority({this.name, this.id});

  Priority.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Department {
  int? id;
  String? name;

  Department({this.name, this.id});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class SubmittedBy {
  int? id;
  String? email;

  SubmittedBy({this.email, this.id});

  SubmittedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
