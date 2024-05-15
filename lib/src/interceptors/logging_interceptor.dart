import 'package:dio/dio.dart';

import '../utility/helper_functions.dart';

class LoggingInterceptor extends Interceptor {
  final bool isLoggerEnabled;

  LoggingInterceptor({this.isLoggerEnabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra["startTime"] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra["startTime"] as DateTime;
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);
    if (isLoggerEnabled) {
      customPrint(
        fromWhere: 'LoggingInterceptor',
        data: '${duration.inMilliseconds}ms',
        type: 'Request Time',
      );
    }
    super.onResponse(response, handler);
  }
}
