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
        TextButton(
          child: const Text('Gastos'),
          onPressed: () => _updateFilter('expenses'),
        ),
        TextButton(
          child: const Text('Ingresos'),
          onPressed: () => _updateFilter('incomes'),
        )
      ],
    );
  }
}