class Transaction {
  final double amount;
  final String category;
  final String date;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'category': category,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
    );
  }
}
