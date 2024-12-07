import 'package:flutter/material.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _timeFilter = 'month';
  String _filter = 'expense';

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        title: const Text("Historial de Transacciones"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('Gastos'),
                onPressed: () {
                  setState(() {
                    _filter = 'expense';
                  });
                },
              ),
              TextButton(
                child: const Text('Ingresos'),
                onPressed:() {
                  setState(() {
                    _filter = 'income';
                  });
                },
              )
            ],
          ),
          // Filtro de tiempo
          Row(
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
              ),
            ],
          ),
                    
          FutureBuilder(
            future: DBHelper.instance.getTransactionsByFilter(_filter, getDateRange(_timeFilter)),
            builder: (context, AsyncSnapshot<List<TransactionData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay transacciones'));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    return ListTile(
                      title: Text(transaction.categoryId.toString()),
                      subtitle: Text(transaction.date),
                      trailing: Text(transaction.amount.toString()),
                    );
                  },
                ),
              );
            },
          )
        ]
      )
    );
  }
}
