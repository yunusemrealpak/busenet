import 'package:dio/dio.dart';

abstract class BaseResponse<T> {
  int? statusCode;
  String? errorMessage;
  DioExceptionType? errorType;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);
}
