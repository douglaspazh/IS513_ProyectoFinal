import 'package:flutter/material.dart';
import 'package:money_app/screens/add/add_category_screen.dart';
import 'package:money_app/screens/base_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Categorías')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Gastos'),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('Ingresos'),
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddCategoryScreen(),
        )),
      ),
    );
  }
}