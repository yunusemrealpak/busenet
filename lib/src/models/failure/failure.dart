abstract class Failure {
  String? message;
  Failure({this.message});
}

class CancelFailure extends Failure {
  CancelFailure({super.message});
}

class TimeoutFailure extends Failure {
  TimeoutFailure({super.message});
}

class ConnectionFailure extends Failure {
  ConnectionFailure({super.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message});
}

class UnknownFailure extends Failure {
  UnknownFailure({super.message});
}

class UnAuthorizedFailure extends Failure {
  UnAuthorizedFailure({super.message});
}

class NotFoundFailure extends Failure {
  NotFoundFailure({super.message});
}
