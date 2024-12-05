class Category {
  final int? id;
  final String name;
  final String type;
  final String? description;

  Category({
    this.id,
    required this.name,
    required this.type,
    this.description
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      description: map['description'],
    );
  }
}