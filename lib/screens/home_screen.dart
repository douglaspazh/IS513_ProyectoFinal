import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/add/add_transaction_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

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
            child: Column(
              children: [
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
                // Gráfico de pastel
                Stack(
                  children: [
                    FutureBuilder(
                      future: DBHelper.instance.getCategoryData(_filter, getDateRange(_timeFilter)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          print(snapshot.data);
                          return SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    showTitle: false,
                                    color: Colors.grey,
                                    value: 1,
                                  ),
                                ],
                                centerSpaceRadius: 70,
                              ),
                            ),
                          );
                        } else {
                          final data = snapshot.data!;
                          final sections = data.entries.map((entry) {
                            return PieChartSectionData(
                              showTitle: false,
                              color: Color(entry.value['iconColor']),
                              value: entry.value['total'],
                            );
                          }).toList();
                          return SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: sections,
                                centerSpaceRadius: 70,
                                sectionsSpace: 2,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // Balance total de transacciones
                    Positioned.fill(
                      child: Center(
                        child: FutureBuilder<double>(
                          future: DBHelper.instance.getBalanceByFilter(_filter, getDateRange(_timeFilter)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (!snapshot.hasData) {
                              return const Text('No hay transacciones');
                            } else {
                              return Text(snapshot.data!.toStringAsFixed(2));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Lista de transacciones
          Expanded(
            child: FutureBuilder(
              future: DBHelper.instance.getTransactionsByFilter(_filter, getDateRange(_timeFilter)),
              builder: (context, AsyncSnapshot<List<TransactionData>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay transacciones registradas'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    final categoryFuture = DBHelper.instance.getCategoryById(transaction.categoryId);
                    return FutureBuilder(
                      future: categoryFuture,
                      builder: (context, AsyncSnapshot<Category> categorySnapshot) {
                        if (categorySnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            title: Text('Cargando...'),
                          );
                        }
                        if (!categorySnapshot.hasData) {
                          return const ListTile(
                            title: Text('Categoría no encontrada'),
                          );
                        }
                        final category = categorySnapshot.data!;
                        return SizedBox(
                          height: 64,
                          child: Card(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Color(category.iconColor),
                                  child: FaIcon(categoryIcons[category.iconCode], color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Text(category.name),
                                const Spacer(),
                                Text(transaction.amount.toString()),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        );
                      },
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
          bool? result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen()
            ),
          );

          // Actualizar la lista de transacciones
          if (result != null && result) {
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