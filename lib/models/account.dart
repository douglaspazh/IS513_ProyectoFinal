class Account {
  final int? id;
  final String name;
  final double? balance;
  final String? description;

  Account({
    this.id,
    required this.name,
    this.balance,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
      description: map['description'],
    );
  }
}
