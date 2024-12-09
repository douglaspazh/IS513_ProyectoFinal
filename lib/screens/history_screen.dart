import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/widgets/time_filter_buttons.dart';
import 'package:money_app/widgets/transaction_listcards.dart';
import 'package:money_app/widgets/type_filter_buttons.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _typeFilter = 'expense';
  String _timeFilter = 'month';


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        title: const Text("Historial de Transacciones"),
      ),
      body: Column(
        children: [
          // Filtro
          TypeFilterButtons(
            onTypeFilterChanged: (filter) => setState(() => _typeFilter = filter),
          ),
          
          // Filtro de tiempo
          TimeFilterButtons(
            onTimeFilterChanged: (filter) => setState(() => _timeFilter = filter),
          ),
                    
          // Lista de transacciones
          Expanded(
            child: TransactionListcards(
              typeFilter: _typeFilter,
              timeFilter: _timeFilter,
            ),
          )
        ]
      )
    );
  }
}
