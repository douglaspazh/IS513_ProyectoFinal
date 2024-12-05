import 'package:flutter/material.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/db_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<TransactionData>> _transactionList;
  String _filter = 'All';

  void _fetchTransactions() {
    setState(() {
      _transactionList = DBHelper.instance.getAllTransactions();
    });
  }

  Future<Map<String, double>> _calculateTotals(List<TransactionData> transactions) async {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    return {'income': totalIncome, 'expense': totalExpense};
  }
  
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }
  
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        title: const Text("Historial de Transacciones"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text("Todos")),
              const PopupMenuItem(value: 'Income', child: Text("Ingresos")),
              const PopupMenuItem(value: 'Expense', child: Text("Gastos")),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: FutureBuilder<List<TransactionData>>(
        future: _transactionList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Ocurrió un error al cargar los datos."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay transacciones registradas."));
          }

          final transactions = snapshot.data!;
          final filteredTransactions = transactions.where((transaction) {
            if (_filter == 'Income') return transaction.isIncome;
            if (_filter == 'Expense') return !transaction.isIncome;
            return true;
          }).toList();

          return FutureBuilder<Map<String, double>>(
            future: _calculateTotals(transactions),
            builder: (context, totalSnapshot) {
              if (!totalSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final totals = totalSnapshot.data!;
              return Column(
                children: [
                  // Resumen de totales
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ingresos: +${totals['income']!.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                        Text(
                          "Gastos: -${totals['expense']!.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(),

                  // Lista filtrada
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        final isIncome = transaction.isIncome;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isIncome ? Colors.green : Colors.red,
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              transaction.category,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(transaction.date),
                            trailing: Text(
                              "${isIncome ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
