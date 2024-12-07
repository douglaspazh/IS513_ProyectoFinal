class Category {
  final int? id;
  final String name;
  final String type;
  final String iconCode;
  final int iconColor;
  final String? description;

  Category({
    this.id,
    required this.name,
    required this.type,
    required this.iconCode,
    required this.iconColor,
    this.description
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconCode': iconCode,
      'iconColor': iconColor,
      'description': description,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      iconCode: map['iconCode'],
      iconColor: map['iconColor'],
      description: map['description'],
    );
  }
}