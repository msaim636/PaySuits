class AddProductBody {
  late String productName;
  late String price;
  late String code;
  late String categoryId;
  late String unitId;
  late String description;

  AddProductBody(
      {required this.productName,
      required this.price,
      required this.code,
      required this.categoryId,
      required this.unitId,
      required this.description});

  AddProductBody.fromJson(Map<String, dynamic> json) {
    productName = json['name'];
    price = json['price'];
    code = json['code'];
    categoryId = json['category_id'];
    unitId = json['unit_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = productName;
    data['price'] = price;
    data['code'] = code;
    data['category_id'] = categoryId;
    data['unit_id'] = unitId;
    data['description'] = description;
    return data;
  }
}
