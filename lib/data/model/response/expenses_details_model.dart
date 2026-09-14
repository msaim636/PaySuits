class ExpensesDetailsModel {
  int? id;
  String? title;
  String? date;
  String? reference;
  dynamic amount;
  dynamic categoryName;
  String? note;
  List<Attachments>? attachments;

  ExpensesDetailsModel(
      {this.id,
      this.title,
      this.date,
      this.reference,
      this.amount,
      this.categoryName,
      this.note,
      this.attachments});

  ExpensesDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    reference = json['reference'];
    amount = json['amount'];
    categoryName = json['category_name'];
    note = json['note'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['reference'] = reference;
    data['amount'] = amount;
    data['category_name'] = categoryName;
    data['note'] = note;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  int? id;
  String? path;
  String? imageableType;
  int? imageableId;
  String? type;
  String? createdAt;
  String? updatedAt;

  Attachments(
      {this.id,
      this.path,
      this.imageableType,
      this.imageableId,
      this.type,
      this.createdAt,
      this.updatedAt});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    imageableType = json['imageable_type'];
    imageableId = json['imageable_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['path'] = path;
    data['imageable_type'] = imageableType;
    data['imageable_id'] = imageableId;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
