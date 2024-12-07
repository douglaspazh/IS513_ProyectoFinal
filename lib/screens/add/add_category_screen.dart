import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/utils/colors.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _categoryType = 'expenses';
  late String _iconCode;
  late int _iconColor;
  bool _isIconSelected = false;
  bool _isColorSelected = false;
  bool _showIconError = false;
  bool _showColorError = false;

  void _saveCategory() {
    setState(() {
      _showIconError = !_isIconSelected;
      _showColorError = !_isColorSelected;
    });

    if (_formKey.currentState!.validate() && _isIconSelected && _isColorSelected) {
      final category = Category(
        name: _nameController.text,
        type: _categoryType,
        iconCode: _iconCode,
        iconColor: _iconColor,
        description: _descriptionController.text,
      );
      DBHelper.instance.insertCategory(category);
      Navigator.of(context).pop(true);
    }
  }

  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Agregar Categoría')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                dismissKeyboard(context);
                return false;
              },
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Nombre de la categoría
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el nombre de la categoría';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  
                  // Tipo de categoría
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tipo de categoría'),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: const Text('Gastos'),
                                value: 'expenses',
                                groupValue: _categoryType,
                                onChanged: (value) {
                                  setState(() {
                                  _categoryType = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text('Ingresos'),
                                value: 'incomes',
                                groupValue: _categoryType,
                                onChanged: (value) {
                                  setState(() {
                                  _categoryType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Icono de la categoría
                  Row(
                    children: [
                      const Text('Icono'),
                      if (_showIconError)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Seleccione un icono',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      for (final icon in categoryIcons.values)
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: _isIconSelected && _iconCode == categoryIcons.entries
                              .firstWhere((entry) => entry.value == icon)
                              .key ? Border.all(color: Colors.blueGrey, width: 2) : null
                          ),
                          child: ClipOval(
                            child: Material(
                              color: _isIconSelected && _isColorSelected && _iconCode == categoryIcons.entries
                                .firstWhere((entry) => entry.value == icon)
                                .key ? Color(_iconColor) : Colors.blueGrey,
                              child: Center(
                                child: FaIcon(icon, color: Colors.white, size: 32),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          dismissKeyboard(context);
                          setState(() {
                            _isIconSelected = true;
                            _showIconError = false;
                            _iconCode = categoryIcons.entries
                              .firstWhere((entry) => entry.value == icon)
                              .key;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Color del icono
                  Row(
                    children: [
                      const Text('Color'),
                      if (_showColorError)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Seleccione un color',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (final color in colorList)
                      GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                            if (_isColorSelected && _iconColor == color.value)
                            const Center(
                              child: FaIcon(FontAwesomeIcons.check, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                        onTap: () {
                          dismissKeyboard(context);
                          setState(() {
                            _isColorSelected = true;
                            _showColorError = false;
                            _iconColor = color.value;
                          });
                        },
                      ),
                    ],
                  ),

                  // Descripción de la categoría
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),

                  const SizedBox(height: 16),

                  // Botón de guardar
                  ElevatedButton(
                    onPressed: _saveCategory,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}