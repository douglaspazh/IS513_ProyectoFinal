import 'package:flutter/material.dart';
import 'package:money_app/screens/base_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Categorías')),
      body: const Center(
        child: Text('Pantalla de categorías'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}