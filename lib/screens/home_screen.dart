import 'package:flutter/material.dart';
import 'package:money_app/screens/add_transaction_screen.dart';
import 'package:money_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const Placeholder(),
    const AddTransactionScreen(),
    const SettingsScreen()
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Gastos')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Menú')
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => _selectPage(0),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Cuentas'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Graficas'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorias'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.notification_important),
              title: const Text('Alertas'),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () => {},
            )
          ],
        ),
      ),
      body: _pages[_selectedPageIndex],
    );
  }
}