import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/screens/add/add_transaction_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/currencies.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

class TransactionDetailScreen extends StatelessWidget {
  final int id;

  const TransactionDetailScreen({super.key,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la transacción')),
      body: FutureBuilder(
        future: DBHelper.instance.getTransactionDetails(id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontraron detalles'));
          }
          final transaction = snapshot.data!;
          return Column(
            children: [
              // Cantidad
              ListTile(
                title: const Text(
                  'Cantidad',
                  style: TextStyle(fontSize: 12, color: Colors.grey)
                ),
                subtitle: Text(
                  "${formatBalance(transaction['amount'])} ${getCurrencySymbol(transaction['currency'])}",
                  style: const TextStyle(fontSize: 15)
                ),
              ),

              // Cuenta
              ListTile(
                title: const Text(
                  'Cuenta',
                  style: TextStyle(fontSize: 12, color: Colors.grey)
                ),
                subtitle: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(transaction['accountColor']),
                      child: FaIcon(getIconData(transaction['accountIcon']), color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transaction['account'],
                      style: const TextStyle(fontSize: 15)
                    ),
                  ],
                ),
              ),
              
              // Categoría
              ListTile(
                title: const Text(
                  'Categoría',
                  style: TextStyle(fontSize: 12, color: Colors.grey)
                ),
                subtitle: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(transaction['categoryColor']),
                      child: FaIcon(getIconData(transaction['categoryIcon']), color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transaction['category'],
                      style: const TextStyle(fontSize: 15)
                    ),
                  ],
                ),
              ),
              
              ListTile(
                title: const Text(
                  'Tipo',
                  style: TextStyle(fontSize: 12, color: Colors.grey)
                ),
                subtitle: Text(
                  transaction['isIncome'] == 0 ? 'Gasto' : 'Ingreso',
                  style: const TextStyle(fontSize: 15)
                ),
              ),
              
              ListTile(
                title: const Text(
                  'Día',
                  style: TextStyle(fontSize: 12, color: Colors.grey)
                ),
                subtitle: Text(
                  formatDateToWords(transaction['date']),
                  style: const TextStyle(fontSize: 15)
                ),
              ),

              // Descripción
              if (transaction['description'].isNotEmpty)
              ListTile(
                title: const Text(
                  'Descripción',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: SizedBox(
                  child:Text(
                    transaction['description'],
                    style: const TextStyle(fontSize: 15),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis
                  )
                ),
              ),

              const SizedBox(height: 16),

              // Botón de editar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Editar'),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddTransactionScreen(id: id, isEditing: true),
                        ),
                      );
                  
                      if (result != null && result && context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),

                  // Botón de eliminar
                  ElevatedButton(
                    child: const Text('Eliminar'),
                    onPressed: () async {
                      final dialogConfirm = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text('¿Estás seguro de que deseas eliminar esta transacción?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text('Eliminar'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                          );
                        },
                      );

                      if (dialogConfirm == true) {
                        final result = await DBHelper.instance.deleteTransaction(id);
                        if (result && context.mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                  )
                ],
              ),
            ],
          );
        }
      )
    );
  }
}