import 'package:flutter/material.dart';
import 'package:money_app/utils/common_funcs.dart';
import 'package:money_app/utils/db_helper.dart';

class BalanceText extends StatelessWidget {
  final String typeFilter;
  final String? timeFilter;
  final TextStyle? style;

  const BalanceText({super.key, required this.typeFilter, this.style, this.timeFilter});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: typeFilter == 'all' 
        ? DBHelper.instance.getTotalBalance() 
        : DBHelper.instance.getBalanceByFilter(typeFilter, getDateRange(timeFilter!)),
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Text(
            '0 L',
            style: style,
          );
        }
        final data = snapshot.data!;
        return Text(
          '${formatBalance(data)} L',
          style: style,
        );
      }
    );
  }
}