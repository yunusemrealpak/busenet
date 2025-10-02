import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart'
    hide BaseResponse;

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
    CachePolicy? cachePolicy,
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
    CachePolicy? cachePolicy,
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
