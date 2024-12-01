import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Ajustes',
      body: Center(
        child: Text('Pantalla de ajustes'),
      )
    );
  }
}