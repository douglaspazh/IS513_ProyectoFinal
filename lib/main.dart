import 'package:flutter/material.dart';
import 'package:money_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Gastos',
      home: HomeScreen(),
    );
  }
}
