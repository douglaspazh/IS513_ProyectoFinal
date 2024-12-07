import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, IconData> accountIcons = {
  'bank': FontAwesomeIcons.landmark,
  'cash': FontAwesomeIcons.moneyBills,
  'credit_card': FontAwesomeIcons.creditCard,
  'wallet': FontAwesomeIcons.wallet,
  'piggy_bank': FontAwesomeIcons.piggyBank,
  'vault': FontAwesomeIcons.vault,
  'investment': FontAwesomeIcons.chartLine,
  'money_bag': FontAwesomeIcons.sackDollar,
  'money_check': FontAwesomeIcons.moneyCheck,
  'tips': FontAwesomeIcons.coins,
  'dollar_sign': FontAwesomeIcons.dollarSign,
  'euro_sign': FontAwesomeIcons.euroSign,
  'btc_sign': FontAwesomeIcons.btc,
  'eth_sign': FontAwesomeIcons.ethereum,
  'other': FontAwesomeIcons.circleQuestion,
};

const Map<String, IconData> categoryIcons = {
  // Finanzas
  'bank': FontAwesomeIcons.landmark,
  'salary': FontAwesomeIcons.handHoldingDollar,
  'credit_card': FontAwesomeIcons.creditCard,
  'investment': FontAwesomeIcons.chartLine,
  
  // Alimentación
  'burger': FontAwesomeIcons.burger,
  'water_bottle': FontAwesomeIcons.bottleWater,

  'other': FontAwesomeIcons.circleQuestion,
};

getIconData(String iconCode) {
  if (accountIcons.containsKey(iconCode)) {
    return accountIcons[iconCode];
  } else if (categoryIcons.containsKey(iconCode)) {
    return categoryIcons[iconCode];
  }
  return categoryIcons['other'];
}
