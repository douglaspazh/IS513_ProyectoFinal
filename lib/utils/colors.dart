import 'package:flutter/material.dart';

List colorList = [
  Colors.teal[300],
  Colors.green[300],
  Colors.red[400],
  Colors.blue[300],
  Colors.purple[300],
  Colors.orange[300],
];

List allColors = Colors.primaries.expand(
  (color) => List.generate(10, (shade) => color[shade * 100]).where((c) => c != null)
).toList();
