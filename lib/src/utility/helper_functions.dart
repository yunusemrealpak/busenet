import 'package:flutter/material.dart';

void customPrint({
  required String fromWhere,
  required String data,
  String? type,
}) {
  debugPrint(
    "👉 [ DEBUG PRINT ] [ $fromWhere ] ${type == null ? "" : " [ $type ] "} $data",
  );
}

double convertToPercentile(double value) {
  if (value < 0.0 || value > 1.0) {
    throw ArgumentError('Değer 0 ile 1 arasında olmalıdır.');
  }

  final percentile = (value * 100).round();
  return percentile.toDouble();
}
