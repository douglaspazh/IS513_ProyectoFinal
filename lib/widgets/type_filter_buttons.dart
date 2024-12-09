import 'package:flutter/material.dart';

class TypeFilterButtons extends StatefulWidget {
  final ValueChanged<String> onTypeFilterChanged;

  const TypeFilterButtons({super.key, required this.onTypeFilterChanged});

  @override
  State<TypeFilterButtons> createState() => _TypeFilterButtonsState();
}

class _TypeFilterButtonsState extends State<TypeFilterButtons> {
  String _selectedFilter = 'expenses';

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    widget.onTypeFilterChanged(filter);
    }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => _updateFilter('expenses'),
            child: Text(
              'Gastos',
              style: TextStyle(
                fontSize: 16,
                color: _selectedFilter == 'expenses' ? Colors.green[600] : Colors.grey[800],
                decoration: _selectedFilter == 'expenses'
                  ? TextDecoration.underline
                  : null,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => _updateFilter('incomes'),
            child: Text(
              'Ingresos',
              style: TextStyle(
                fontSize: 16,
                color: _selectedFilter == 'incomes' ? Colors.green[600] : Colors.grey[800],
                decoration: _selectedFilter == 'incomes'
                  ? TextDecoration.underline
                  : null,
              )
            ),
          ),
        )
      ],
    );
  }
}