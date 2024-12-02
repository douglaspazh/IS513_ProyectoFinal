import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Configuraciones')),
      body: const Center(
        child: Text('Pantalla de ajustes'),
      )
    );
  }
}