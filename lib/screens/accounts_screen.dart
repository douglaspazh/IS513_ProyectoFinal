import 'package:flutter/material.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/screens/add/add_account_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/db_helper.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> _accounts = [];

  void _loadAccounts() async {
    final accounts = await DBHelper.instance.getAllAccounts();
    setState(() {
      _accounts = accounts;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Cuentas')),
      body: _accounts.isEmpty
        ? const Center(child: Text('No hay cuentas registradas'))
        : ListView.builder(
          itemCount: _accounts.length,
          itemBuilder: (context, index) {
            final account = _accounts[index];
            return ListTile(
              title: Text(account.name),
              subtitle: Text(account.balance.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar cuenta'),
                      content: const Text('¿Estás seguro de eliminar esta cuenta?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Eliminar'),
                          onPressed: () {
                            DBHelper.instance.deleteAccount(account.id!);
                            Navigator.of(context).pop();
                            _loadAccounts();
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AddAccountScreen(),
        ))
      ),
    );
  }
}