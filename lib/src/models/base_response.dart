import 'failure/failure.dart';

abstract class BaseResponse<T> {
  int? httpStatus;
  int? statusCode;
  String? errorMessage;
  Failure? errorType;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);
}
