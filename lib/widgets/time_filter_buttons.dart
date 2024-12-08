import 'package:flutter/material.dart';

class TimeFilterButtons extends StatefulWidget {
  final ValueChanged<String> onTimeFilterChanged;

  const TimeFilterButtons({super.key, required this.onTimeFilterChanged});

  @override
  State<TimeFilterButtons> createState() => _TimeFilterButtonsState();
}

class _TimeFilterButtonsState extends State<TimeFilterButtons> {
  String _selectedFilter = 'month';

  void _updateFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    widget.onTimeFilterChanged(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          child: const Text('Día'),
          onPressed: () => setState(() => _updateFilter('day')),
        ),
        TextButton(
          child: const Text('Semana'),
          onPressed: () => setState(() => _updateFilter('week')),
        ),
        TextButton(
          child: const Text('Mes'),
          onPressed: () => setState(() => _updateFilter('month')),
        ),
        TextButton(
          child: const Text('Año'),
          onPressed: () => setState(() => _updateFilter('year')),
        ),
        TextButton(
          child: const Text('Periodo'),
          onPressed: () {},
        ),
      ],
    );
  }
}