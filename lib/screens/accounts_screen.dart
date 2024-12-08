import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/screens/add/add_account_screen.dart';
import 'package:money_app/screens/base_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/currencies.dart';
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
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final account = snapshot.data![index];
                return SizedBox(
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        CircleAvatar(
                          backgroundColor: Color(account.iconColor),
                          child: FaIcon(getIconData(account.iconCode), color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 8),
                        Text(account.name),
                        const Spacer(),
                        Text("${getCurrencySymbol(account.currency)} ${formatBalance(account.balance!)}"),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
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