part of '../dio/core_dio.dart';

Failure handleError(DioExceptionType errorType, ErrorMessages? errorMessages) {
  switch (errorType) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutFailure(
          message: errorMessages?.timeoutErrorMessage,
          dioError: errorType.toString());
    case DioExceptionType.connectionError:
      return ConnectionFailure(
          message: errorMessages?.connectionErrorMessage,
          dioError: errorType.toString());
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
      return ServerFailure(
          message: errorMessages?.serverErrorMessage,
          dioError: errorType.toString());
    case DioExceptionType.cancel:
      return CancelFailure(
          message: errorMessages?.cancelErrorMessage,
          dioError: errorType.toString());
    case DioExceptionType.unknown:
      return UnknownFailure(
          message: errorMessages?.unknownErrorMessage,
          dioError: errorType.toString());
  }
}
