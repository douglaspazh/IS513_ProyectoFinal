import 'package:flutter/material.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/add_transaction_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionData> _transactions = [];

  void _addTransaction(TransactionData transaction) async {
    await DBHelper.instance.insertTransaction(transaction);
    _loadTransactions();
  }

  void _loadTransactions() async {
    final transactions = await DBHelper.instance.fetchTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Gestión de Gastos',
      body: Column(
        children: [
          const Center(
            child: Text(
              '¡Bienvenido a Gestión de Gastos!',
              style: TextStyle(fontSize: 18),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(_transactions[index].category),
                  subtitle: Text('Monto: ${_transactions[index].amount}'),
                  trailing: Text(_transactions[index].date),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddTransactionScreen(onAddTransaction: _addTransaction),
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}