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
  String _filter = 'expenses';
  String _timeFilter = 'month';

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Gestión de Gastos')),
      body: Column(
        children: [
          // Filtro de transacciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('Gastos'),
                onPressed: () => setState(() => _filter = 'expenses'),
              ),
              TextButton(
                child: const Text('Ingresos'),
                onPressed: () => setState(() => _filter = 'incomes'),
              )
            ],
          ),

          // Filtro de tiempo
          Card(
            margin: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Día'),
                  onPressed: () => setState(() => _timeFilter = 'day'),
                ),
                TextButton(
                  child: const Text('Semana'),
                  onPressed: () => setState(() => _timeFilter = 'week'),
                ),
                TextButton(
                  child: const Text('Mes'),
                  onPressed: () => setState(() => _timeFilter = 'month'),
                ),
                TextButton(
                  child: const Text('Año'),
                  onPressed: () => setState(() => _timeFilter = 'year'),
                ),
                TextButton(
                  child: const Text('Periodo'),
                  onPressed: () {},
                )
              ],
            ),
          ),

          // Lista de transacciones
          Expanded(
            child: FutureBuilder(
              future: DBHelper.instance.getTransactionsByFilter(_filter, _timeFilter),
              builder: (context, AsyncSnapshot<List<TransactionData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay transacciones registradas'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    return ListTile(
                      title: Text(transaction.category),
                      subtitle: Text(transaction.amount.toString()),
                      trailing: Text(transaction.date),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen()
            ),
          );

          // Actualizar la lista de transacciones
          if (result == true) {
            setState(() {
              _filter = _filter;
              _timeFilter = _timeFilter;
            });
          }
        }
      ),
    );
  }
}