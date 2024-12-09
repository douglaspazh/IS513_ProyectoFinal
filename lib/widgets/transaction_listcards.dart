import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/models/transaction.dart';
import 'package:money_app/screens/detail/transaction_detail_screen.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/currencies.dart';
import 'package:money_app/utils/db_helper.dart';
import 'package:money_app/utils/icons.dart';

class TransactionListcards extends StatelessWidget {
  final String typeFilter;
  final String timeFilter;
  
  const TransactionListcards({super.key,
    required this.typeFilter,
    required this.timeFilter
  });

  Future<String> getAccountCurrency(int accountId) async {
    final account = await DBHelper.instance.getAccountById(accountId);
    return account.currency;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper.instance.getTransactionsByFilter(typeFilter, getDateRange(timeFilter)),
      builder: (context, AsyncSnapshot<List<TransactionData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay transacciones registradas'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final transaction = snapshot.data![index];
            final categoryFuture = DBHelper.instance.getCategoryById(transaction.categoryId);
            return FutureBuilder(
              future: categoryFuture,
              builder: (context, AsyncSnapshot<Category> categorySnapshot) {
                if (categorySnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final category = categorySnapshot.data!;
                return SizedBox(
                  height: 64,
                  child: GestureDetector(
                    child: Card(
                      child: Row(
                        children: [
                          const SizedBox(width: 8),

                          // Icono de categoría
                          CircleAvatar(
                            backgroundColor: Color(category.iconColor),
                            child: FaIcon(categoryIcons[category.iconCode], color: Colors.white),
                          ),

                          const SizedBox(width: 8),
                          
                          // Nombre de categoría
                          Text(category.name),

                          const Spacer(),
                          
                          // Monto de transacción
                          FutureBuilder(
                            future: getAccountCurrency(transaction.accountId),
                            builder: (context, AsyncSnapshot<String> currencySnapshot) {
                              if (currencySnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final currency = currencySnapshot.data!;
                              return Text(
                                '${formatBalance(transaction.amount)} ${getCurrencySymbol(currency)}',
                              );
                            },
                          ),
                          
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailScreen(id: transaction.id as int),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}