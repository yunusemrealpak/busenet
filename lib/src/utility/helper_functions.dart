import 'package:busenet/src/enums/bn_cache_policy.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
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

CachePolicy mapBNCachePolicyToDioCachePolicy(BNCachePolicy? policy) {
  switch (policy) {
    case BNCachePolicy.forceCache:
      return CachePolicy.forceCache;
    case BNCachePolicy.refreshForceCache:
      return CachePolicy.refreshForceCache;
    case BNCachePolicy.noCache:
      return CachePolicy.noCache;
    case BNCachePolicy.refresh:
      return CachePolicy.refresh;
    case BNCachePolicy.request:
      return CachePolicy.request;
    default:
      return CachePolicy.noCache;
  }
}
