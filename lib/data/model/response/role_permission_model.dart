
class RolePermission {
  final dynamic id;
  final String name;
  final String groupName;
  final String translatedName;
  RolePermission({
    required this.id,
    required this.name,
    required this.groupName,
    required this.translatedName,
  });
  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
      id: json['id'],
      name: json['name'],
      groupName: json['group_name'],
      translatedName: json['translated_name'],
    );
  }
}


