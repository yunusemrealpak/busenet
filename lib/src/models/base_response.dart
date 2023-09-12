import 'failure/failure.dart';

abstract class BaseResponse<T> {
  int? responseStatus;
  int? statusCode;
  String? errorMessage;
  Failure? errorType;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);

  void clearResponse() {
    responseStatus = null;
    statusCode = null;
    errorMessage = null;
    errorType = null;

    clearEntity();
  }

  void clearEntity();
}
