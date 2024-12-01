import 'package:flutter/material.dart';
import 'package:money_app/screens/add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _selectPage(String route) {
    Navigator.of(context).popAndPushNamed(route);
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
              onTap: () => _selectPage('/home'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () => _selectPage('/history'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Cuentas'),
              onTap: () => _selectPage('/accounts'),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Graficas'),
              onTap: () => _selectPage('/charts'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorias'),
              onTap: () => _selectPage('/categories'),
            ),
            ListTile(
              leading: const Icon(Icons.notification_important),
              title: const Text('Alertas'),
              onTap: () => _selectPage('/alerts'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () => _selectPage('/settings'),
            )
          ],
        ),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}