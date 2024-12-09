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
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () => setState(() => _updateFilter('day')),
              child: Text(
                'Día',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFilter == 'day' ? Colors.green[600] : Colors.grey[800],
                  decoration: _selectedFilter == 'day'
                    ? TextDecoration.underline
                    : null,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () => setState(() => _updateFilter('week')),
              child: Text(
                'Semana',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFilter == 'week' ? Colors.green[600] : Colors.grey[800],
                  decoration: _selectedFilter == 'week'
                    ? TextDecoration.underline
                    : null,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () => setState(() => _updateFilter('month')),
              child: Text(
                'Mes',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFilter == 'month' ? Colors.green[600] : Colors.grey[800],
                  decoration: _selectedFilter == 'month'
                    ? TextDecoration.underline
                    : null,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () => setState(() => _updateFilter('year')),
              child: Text(
                'Año',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFilter == 'year' ? Colors.green[600] : Colors.grey[800],
                  decoration: _selectedFilter == 'year'
                    ? TextDecoration.underline
                    : null,
                )
              ),
            ),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Periodo',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFilter == 'period' ? Colors.green[600] : Colors.grey[800],
                  decoration: _selectedFilter == 'period'
                    ? TextDecoration.underline
                    : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}