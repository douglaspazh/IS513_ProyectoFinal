import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';
import 'package:money_app/widgets/type_filter_buttons.dart';

class AddTransactionScreen extends StatefulWidget {
  final bool isEditing;
  final int? id;

  const AddTransactionScreen({super.key,
    this.isEditing = false,
    this.id
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  int? _selectedAccountId;
  int? _selectedCategoryId;

  double _oldAmount = 0;
  bool _isIncome = false;
  List<Account> _accounts = [];
  List<Category> _categories = [];

  void _loadAccounts() async {
    final accounts = await DBHelper.instance.getAllAccounts();
    setState(() {
      _accounts = accounts;
      if (_accounts.isNotEmpty) {
        _selectedAccountId = _accounts.first.id!;
      }
    });
  }

  void _loadCategories() async {
    final categories = await DBHelper.instance.getAllCategories();
    setState(() {
      _categories = categories;
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories.first.id!;
      }
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2001),
      lastDate: DateTime.now(),
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
        accountId: _selectedAccountId!,
        categoryId: _selectedCategoryId!,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        isIncome: _isIncome,
        description: _descriptionController.text,
      );

      if (widget.isEditing) {
        // Actualizar balance de cuenta
        DBHelper.instance.updateAccountBalance(transaction.accountId, _oldAmount, false);
        DBHelper.instance.updateAccountBalance(transaction.accountId, transaction.amount, _isIncome);
        DBHelper.instance.updateTransaction(widget.id!, transaction);
      } else {
        DBHelper.instance.insertTransaction(transaction);
        DBHelper.instance.updateAccountBalance(transaction.accountId, transaction.amount, transaction.isIncome);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _loadCategories();

    if (widget.isEditing) {
      DBHelper.instance.getTransactionById(widget.id!).then((transaction) {
        setState(() {
          _oldAmount = transaction.amount;
          _amountController.text = transaction.amount.toString();
          _selectedAccountId = transaction.accountId;
          _selectedCategoryId = transaction.categoryId;
          _selectedDate = DateTime.parse(transaction.date);
          _isIncome = transaction.isIncome;
          _descriptionController.text = transaction.description ?? '';
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Editar Transacción' : 'Agregar Transacción'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Ingreso o Gasto
              TypeFilterButtons(
                onTypeFilterChanged: (filter) => setState(() => _isIncome = (filter == 'incomes' ? true : false)),
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

              // Seleccionar cuenta
              DropdownButtonFormField(
                value: _selectedAccountId,
                items: _accounts.map((account) {
                  return DropdownMenuItem(
                    value: account.id,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(account.iconColor),
                          child: FaIcon(getIconData(account.iconCode), color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(account.name),
                      ],
                    ),
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

              // Seleccionar categoria
              DropdownButtonFormField(
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(category.iconColor),
                          child: FaIcon(getIconData(category.iconCode), color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedCategoryId = value as int;
                }),
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  value == null ? 'Seleccione una categoría' : null;
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