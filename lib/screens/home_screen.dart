import 'package:flutter/material.dart';
import 'package:money_app/screens/add_transaction_screen.dart';
import 'package:money_app/screens/base_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Gestión de Gastos',
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}