import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/colors.dart';
import 'package:money_app/utils/icons.dart';

class AddAccountScreen extends StatefulWidget {
  final bool isEditing;
  final int? id;

  const AddAccountScreen({super.key,
    this.isEditing = false,
    this.id = 0
  });

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isIconSelected = false;
  bool _isColorSelected = false;
  bool _showIconError = false;
  bool _showColorError = false;
  late String _iconCode;
  late int _iconColor;

  void _saveAccount() {
    setState(() {
      _showIconError = !_isIconSelected;
      _showColorError = !_isColorSelected;
    });

    if (_formKey.currentState!.validate() && _isIconSelected && _isColorSelected) {
      final account = Account(
        name: _nameController.text,
        balance: double.parse(_balanceController.text),
        iconCode: _iconCode,
        iconColor: _iconColor,
        description: _descriptionController.text,
      );
      
    if (widget.isEditing) {
      DBHelper.instance.updateAccount(widget.id!, account);
    } else {
      DBHelper.instance.insertAccount(account);
    }

      Navigator.of(context).pop(true);
    }
  }

  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.isEditing) {
      DBHelper.instance.getAccountById(widget.id!).then((account) {
        setState(() {
          _nameController.text = account.name;
          _balanceController.text = account.balance.toString();
          _iconCode = account.iconCode;
          _iconColor = account.iconColor;
          _descriptionController.text = account.description ?? '';
          _isIconSelected = true;
          _isColorSelected = true;
          _showIconError = false;
          _showColorError = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEditing ? 'Editar Cuenta' : 'Agregar Cuenta'
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                dismissKeyboard(context);
                return false;
              },
              child: ListView(
                shrinkWrap: true,
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
                  Row(
                    children: [
                      const Text('Icono'),
                      if (_showIconError)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Selecciona un ícono',
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
                      for (final icon in accountIcons.values)
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: _isIconSelected && _iconCode == accountIcons.entries
                              .firstWhere((entry) => entry.value == icon)
                              .key ? Border.all(color: Colors.blueGrey, width: 2) : null
                          ),
                          child: ClipOval(
                            child: Material(
                              color: _isIconSelected && _isColorSelected && _iconCode == accountIcons.entries
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
                            _iconCode = accountIcons.entries
                              .firstWhere((entry) => entry.value == icon)
                              .key;
                          });
                        },
                      )
                    ],
                  ),
              
                  const SizedBox(height: 16),
              
                  // Selección de color
                  Row(
                    children: [
                      const Text('Color'),
                      if (_showColorError)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Selecciona un color',
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
                              const Icon(Icons.check, color: Colors.white),
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
                    onPressed: () => _saveAccount(),
                    child: const Text('Guardar'),
                  ),

                  // Botón de eliminar
                  if (widget.isEditing)
                    ElevatedButton(
                      onPressed: () async {
                        final confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: const Text('¿Estás seguro de que deseas eliminar esta cuenta?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete == true) {
                          DBHelper.instance.deleteAccount(widget.id!);
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text('Eliminar'),
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