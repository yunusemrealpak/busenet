part of '../dio/core_dio.dart';

Failure handleError(DioExceptionType errorType, ErrorMessages? errorMessages) {
  switch (errorType) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutFailure(message: errorMessages?.timeoutErrorMessage);
    case DioExceptionType.connectionError:
      return ConnectionFailure(message: errorMessages?.connectionErrorMessage);
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
      return ServerFailure(message: errorMessages?.serverErrorMessage);
    case DioExceptionType.cancel:
      return CancelFailure(message: errorMessages?.cancelErrorMessage);
    case DioExceptionType.unknown:
      return UnknownFailure(message: errorMessages?.unknownErrorMessage);
  }
}
