import 'package:flutter/material.dart';
import 'package:money_app/screens/accounts_screen.dart';
import 'package:money_app/screens/alerts_screen.dart';
import 'package:money_app/screens/categories_screen.dart';
import 'package:money_app/screens/charts_screen.dart';
import 'package:money_app/screens/history_screen.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:money_app/screens/settings_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Gastos',

      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/accounts': (context) => const AccountsScreen(),
        '/charts': (context) => const ChartsScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/settings': (context) => const SettingsScreen()
      },
    );
  }
}
