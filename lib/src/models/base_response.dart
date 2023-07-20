import 'package:busenet/src/models/failure.dart';

abstract class BaseResponse<T> {
  int? statusCode;
  String? errorMessage;
  Failure? errorType;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);
}
