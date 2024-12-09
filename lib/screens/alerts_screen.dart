import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Alertas')),
      body: const Center(child: Text('Alertas')),
    );
  }
}