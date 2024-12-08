import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _typeFilter = 'expenses';
  String _timeFilter = 'month';



  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Gráficos')),
      body: Column(
        children: [
          // Filtros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text('General'),
                onPressed: () => setState(() => _typeFilter = 'all'),
              ),
              TextButton(
                child: const Text('Gastos'),
                onPressed: () => setState(() => _typeFilter = 'expenses'),
              ),
              TextButton(
                child: const Text('Ingresos'),
                onPressed: () => setState(() => _typeFilter = 'incomes'),
              ),
            ],
          ),
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
            ],
          ),
          // Gráficos
          FutureBuilder(
            future: DBHelper.instance.getTransactionsByCategoryAndMonth(_typeFilter),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return BarChart(
                  BarChartData(
                    barGroups: [],
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)
                      )
                    ),
                  ),
                );
              } else {
                final data = snapshot.data!;
                int index = 0;
                final stackItems = data.entries.map((monthlyData) {
                  List<BarChartRodStackItem> groups = [];
                  double previosValue = 0;

                  monthlyData.value.forEach((category, data) {
                    final total = data['total'] as double;
                    final color = Color(data['iconColor'] as int);
                    
                    groups.add(
                      BarChartRodStackItem(
                        previosValue,
                        previosValue + total,
                        color,
                      ),
                    );
                    previosValue += total;
                  });
                  return BarChartGroupData(
                    x: index++,
                    barRods: [
                      BarChartRodData(
                        toY: previosValue,
                        rodStackItems: groups,
                        width: 22,
                      ),
                    ],
                  );
                }).toList();

                return SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: stackItems,
                      gridData: const FlGridData(drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                data.keys.elementAt(value.toInt()),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              );
                            },
                          )
                        )
                      ),
                    ),
                  )
                );
              }
            },
          )
        ],
      )
    );
  }
}
