import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _iconCode;

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final account = Account(
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
        iconCode: _iconCode,
        iconColor: 0,
        description: _descriptionController.text,
      );
      DBHelper.instance.insertAccount(account);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Saldo Inicial
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(labelText: 'Saldo Inicial'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Nombre de la cuenta
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un nombre';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Icono de la cuenta
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  for (final icon in accountIcons.values)
                  ClipOval(
                    child: Material(
                      color: Colors.grey[200],
                      child: InkWell(
                        splashColor: Colors.grey[500],
                        child: Center(
                          child: FaIcon(icon, size: 32),
                        ),
                        onTap: () => setState(() {
                          _iconCode = accountIcons.entries
                            .firstWhere((entry) => entry.value == icon)
                            .key;
                        }),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // Descripción de la cuenta
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              
              const SizedBox(height: 16),

              // Botón de guardar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveAccount();
                  }
                },
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}