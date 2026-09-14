class ProductModel {
  int? id;
  String? name;
  String? code;
  String? categoryName;
  String? price;

  ProductModel({this.id, this.name, this.code, this.categoryName, this.price});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    categoryName = json['category_name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['category_name'] = categoryName;
    data['price'] = price;
    return data;
  }
}
