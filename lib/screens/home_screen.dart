import 'package:flutter/material.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/add/add_transaction_screen.dart';
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
    final transactions = await DBHelper.instance.getAllTransactions();
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
      appBar: AppBar(title: const Text('Gestión de Gastos')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('Gastos'),
                onPressed: () => {},
              ),
              TextButton(
                child: const Text('Ingresos'),
                onPressed:() => {},
              )
            ],
          ),

          Card(
            margin: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Día'),
                  onPressed: () => {},
                ),
                TextButton(
                  child: const Text('Semana'),
                  onPressed: () => {},
                ),
                TextButton(
                  child: const Text('Mes'),
                  onPressed: () => {},
                ),
                TextButton(
                  child: const Text('Año'),
                  onPressed: () => {},
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
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
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddTransactionScreen(),
        )),
      ),
    );
  }
}