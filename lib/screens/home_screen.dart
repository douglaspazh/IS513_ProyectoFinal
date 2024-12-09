import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_app/screens/add/add_transaction_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/widgets/balance_text.dart';
import 'package:money_app/widgets/time_filter_buttons.dart';
import 'package:money_app/widgets/transaction_listcards.dart';
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
                        child: BalanceText(typeFilter: _typeFilter, timeFilter: _timeFilter)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Lista de transacciones
          Expanded(
            child: TransactionListcards(
              typeFilter: _typeFilter,
              timeFilter: _timeFilter
            )
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