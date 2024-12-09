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

// Formatear balance con separador de miles y dos decimales si es necesario
String formatBalance(double balance) {
  final formatter = NumberFormat('#,##0.##', 'en_US');
  return formatter.format(balance);
}

// Formatear fecha
String formatDate(String date) {
  final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  return DateFormat('dd/MM/yyyy').format(parsedDate);
}

// Formatear fecha a palabras
String formatDateToWords(String date) {
  final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  final DateFormat formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES');
  return formatter.format(parsedDate);
}

// Formatear mes y año
String formatMonthYear(String date) {
  final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  final DateFormat formatter = DateFormat('MMMM yyyy', 'es_ES');
  return formatter.format(parsedDate);
}

String formatMonthShort(String date) {
  final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
  final DateFormat formatter = DateFormat('MMM', 'es_ES');
  return formatter.format(parsedDate);
}

String getMonthKey(String month) {
  switch (month) {
    case '01':
      return 'ene';
    case '02':
      return 'feb';
    case '03':
      return 'mar';
    case '04':
      return 'abr';
    case '05':
      return 'may';
    case '06':
      return 'jun';
    case '07':
      return 'jul';
    case '08':
      return 'ago';
    case '09':
      return 'sep';
    case '10':
      return 'oct';
    case '11':
      return 'nov';
    case '12':
      return 'dic';
    default:
      return '';
  }
}