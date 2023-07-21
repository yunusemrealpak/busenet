// ignore_for_file: public_member_api_docs, sort_constructors_first
class ErrorMessages {
  String? timeoutErrorMessage;
  String? connectionErrorMessage;
  String? serverErrorMessage;
  String? unknownErrorMessage;
  String? unAuthorizedErrorMessage;
  String? notFoundErrorMessage;
  String? cancelErrorMessage;
  ErrorMessages({
    this.timeoutErrorMessage = 'Timeout',
    this.connectionErrorMessage = 'Connection Error',
    this.serverErrorMessage = 'Server Error',
    this.unknownErrorMessage = 'Unknown Error',
    this.unAuthorizedErrorMessage = 'UnAuthorized',
    this.notFoundErrorMessage = 'Not Found',
    this.cancelErrorMessage = 'Cancel',
  });
}
