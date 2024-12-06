import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/utils/db_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool _isIncome = false;
  int? _selectedAccountId;
  List<Account> _accounts = [];

  void _loadAccounts() async {
    final accounts = await DBHelper.instance.getAllAccounts();
    setState(() {
      _accounts = accounts;
      if (_accounts.isNotEmpty) {
        _selectedAccountId = _accounts.first.id;
      }
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = TransactionData(
        amount: double.parse(_amountController.text),
        category: _categoryController.text,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        description: _descriptionController.text,
        isIncome: _isIncome,
        accountId: _selectedAccountId!,
      );

      DBHelper.instance.insertTransaction(transaction);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Transacción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Ingreso o Gasto
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text('Gasto'),
                    onPressed: () => setState(() => _isIncome = false),
                  ),
                  TextButton(
                    child: const Text('Ingreso'),
                    onPressed: () => setState(() => _isIncome = true),
                  ),
                ],
              ),

              // Monto
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  return null;
                },
              ),

              // Cuenta
              DropdownButtonFormField(
                value: _selectedAccountId,
                items: _accounts.map((account) {
                  return DropdownMenuItem(
                    value: account.id,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedAccountId = value as int;
                }),
                decoration: const InputDecoration(labelText: 'Cuenta'),
                validator: (value) {
                  value == null ? 'Seleccione una cuenta' : null;
                  return null;
                },
              ),

              // Categoria
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una categoría';
                  }
                  return null;
                },
              ),
              
              // Fecha
              ListTile(
                title: Text('Fecha: ${DateFormat.yMd().format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),

              // Descripcion
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),

              const SizedBox(height: 20),
              
              // Guardar transaccion
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}