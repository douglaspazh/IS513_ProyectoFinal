class Account {
  final int? id;
  final String name;
  final double? balance;
  final String iconCode;
  final int iconColor;
  final String? description;

  Account({
    this.id,
    required this.name,
    this.balance,
    required this.iconCode,
    required this.iconColor,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'iconCode': iconCode,
      'iconColor': iconColor,
      'description': description,
    };
  }

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
      iconCode: map['iconCode'],
      iconColor: map['iconColor'],
      description: map['description'],
    );
  }
}
