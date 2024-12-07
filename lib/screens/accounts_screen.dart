import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/screens/add/add_account_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(title: const Text('Cuentas')),
      body: FutureBuilder(
          future: DBHelper.instance.getAllAccounts(),
          builder: (context, AsyncSnapshot<List<Account>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay cuentas'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final account = snapshot.data![index];
                return ListTile(
                  leading: FaIcon(accountIcons[account.iconCode], color: Color(account.iconColor)),
                  title: Text(account.name),
                  trailing: Text(account.balance.toString()),
                );
              },
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddAccountScreen()
            )
          );

          // Actualizar la pantalla si se agrega una cuenta
          if (result != null && result) {
            setState(() {});
          }
        }
      ),
    );
  }
}