abstract class Failure {
  String? message;
  String? dioError;
  Failure({this.message, this.dioError});
}

class CancelFailure extends Failure {
  CancelFailure({super.message, super.dioError});
}

class TimeoutFailure extends Failure {
  TimeoutFailure({super.message, super.dioError});
}

class ConnectionFailure extends Failure {
  ConnectionFailure({super.message, super.dioError});
}

class ServerFailure extends Failure {
  ServerFailure({super.message, super.dioError});
}

class UnknownFailure extends Failure {
  UnknownFailure({super.message, super.dioError});
}

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure({super.message, super.dioError});
}

class NotFoundFailure extends Failure {
  NotFoundFailure({super.message, super.dioError});
}
