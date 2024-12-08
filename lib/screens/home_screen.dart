import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/add/add_transaction_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/screens/detail/transaction_detail_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';
import 'package:money_app/widgets/time_filter_buttons.dart';
import 'package:money_app/widgets/type_filter_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _typeFilter = 'expenses';
  String _timeFilter = 'month';

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Gestión de Gastos')),
      body: Column(
        children: [
          // Filtro de transacciones
          TypeFilterButtons(
            onTypeFilterChanged: (filter) => setState(() => _typeFilter = filter)
          ),

          // Gráfico de pastel y balance total
          Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Filtro de tiempo
                TimeFilterButtons(
                  onTimeFilterChanged: (filter) => setState(() => _timeFilter = filter)
                ),

                // Gráfico de pastel
                Stack(
                  children: [
                    FutureBuilder(
                      future: DBHelper.instance.getCategoryData(_typeFilter, getDateRange(_timeFilter)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return AspectRatio(
                            aspectRatio: 1.5,
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
                          return AspectRatio(
                            aspectRatio: 1.5,
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
                          future: DBHelper.instance.getBalanceByFilter(_typeFilter, getDateRange(_timeFilter)),
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
              future: DBHelper.instance.getTransactionsByFilter(_typeFilter, getDateRange(_timeFilter)),
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
                          child: GestureDetector(
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
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(id: transaction.id as int),
                                ),
                              );
                            },
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
              _typeFilter = _typeFilter;
              _timeFilter = _timeFilter;
            });
          }
        }
      ),
    );
  }
}