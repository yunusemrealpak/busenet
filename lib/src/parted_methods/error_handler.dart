part of '../dio/core_dio.dart';

Failure handleError(DioExceptionType errorType) {
  switch (errorType) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutFailure();
    case DioExceptionType.connectionError:
      return ConnectionFailure();
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
      return ServerFailure();
    case DioExceptionType.cancel:
      return CancelFailure();
    case DioExceptionType.unknown:
      return UnknownFailure();
  }
}
