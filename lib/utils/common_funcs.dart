import 'package:intl/intl.dart';

// Obtener rango de fechas según filtro de tiempo
List getDateRange(String timeFilter) {
  final DateTime now = DateTime.now();
  final DateTime startDate0;
  final DateTime endDate0;

  switch (timeFilter) {
    case 'day':
      startDate0 = now;
      endDate0 = now;
    case 'week':
      final weekday = now.weekday;
      startDate0 = now.subtract(Duration(days: weekday - 1));
      endDate0 = now.add(Duration(days: 7 - weekday));
    case 'month':
      startDate0 = DateTime(now.year, now.month, 1);
      endDate0 = DateTime(now.year, now.month + 1, 0);
    case 'year':
      startDate0 = DateTime(now.year, 1, 1);
      endDate0 = DateTime(now.year, 12, 31);
    case 'period': // TODO: Implement date range picker
      startDate0 = now;
      endDate0 = now;
    default:
      startDate0 = now;
      endDate0 = now;
  }

  final startDate = DateFormat('yyyy-MM-dd').format(startDate0);
  final endDate = DateFormat('yyyy-MM-dd').format(endDate0);

  return [startDate, endDate];
}

// Formatear balance con dos decimales si es necesario
getFormattedBalance(double balance) {
  if (balance % 1 == 0) {
    return balance.toStringAsFixed(0);
  } else {
    return balance.toStringAsFixed(2);
  }
  }