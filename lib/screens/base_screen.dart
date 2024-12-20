import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final AppBar appBar;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const BaseScreen({super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButton
  });

  void _selectPage(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/assets/user.png'),
                  ),
                  SizedBox(height: 10),
                  Text('Douglas Paz', style: TextStyle(color: Colors.black, fontSize: 20)),
                  Text('douglas.paz@unah.hn', style: TextStyle(color: Colors.black, fontSize: 15)),
                ],
              )
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => _selectPage(context, '/home'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () => _selectPage(context, '/history'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Cuentas'),
              onTap: () => _selectPage(context, '/accounts'),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Graficas'),
              onTap: () => _selectPage(context, '/charts'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorias'),
              onTap: () => _selectPage(context, '/categories'),
            ),
            ListTile(
              leading: const Icon(Icons.notification_important),
              title: const Text('Alertas'),
              onTap: () => _selectPage(context, '/alerts'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () => _selectPage(context, '/settings'),
            )
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}