import 'dart:io';

import 'package:busenet/src/enums/bn_cache_policy.dart';
import 'package:dio/dio.dart';

import '../enums/http_types.dart';
import '../models/base_entity.dart';
import '../models/base_response.dart';
import '../utility/typedefs.dart';

abstract class ICoreDio<T extends BaseResponse<T>> {
  void addHeader(Map<String, dynamic> value);
  void addAuthorizationHeader(String token);
  void removeHeader(String key);
  void removeAuthorizationHeader();

  void addInterceptor(Interceptor interceptor);

  Future<T> send<E extends BaseEntity<E>, R>(
    String path, {
    required E parserModel,
    required HttpTypes type,
    String contentType = Headers.jsonContentType,
    ResponseType responseType = ResponseType.json,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,

    /// Cache Options
    BNCachePolicy? cachePolicy,
    Duration? maxStale,

    // Entity Options
    bool ignoreEntityKey = false,
    String? insideEntityKey,
  });

  Future<T> sendPrimitive<E, R>(
    String path, {
    required HttpTypes type,
    String contentType = Headers.jsonContentType,
    ResponseType responseType = ResponseType.json,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,

    /// Cache Options
    BNCachePolicy? cachePolicy,
    Duration? maxStale,

    // Entity Options
    bool ignoreEntityKey = false,
    String? insideEntityKey,
  });

  // download file from url
  Future<File> downloadFile(
    String urlPath, {
    ProgressCallback? onReceiveProgress,
    ProgressPercentageCallback? onReceiveProgressPercentage,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  });
}
