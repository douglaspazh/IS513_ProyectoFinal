import 'package:flutter/material.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/utils/db_helper.dart';

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

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final account = Account(
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(labelText: 'Saldo Inicial'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 16),
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