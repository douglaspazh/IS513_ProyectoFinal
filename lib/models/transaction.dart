class TransactionData {
  final int? id;
  final double amount;
  final String category;
  final String date;
  final String? description;
  final bool isIncome;

  TransactionData({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    required this.isIncome
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
      'isIncome': isIncome ? 1 : 0
    };
  }

  factory TransactionData.fromMap(Map<String, dynamic> map) {
    return TransactionData(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
      description: map['description'],
      isIncome: map['isIncome'] == 1
    );
  }
}
