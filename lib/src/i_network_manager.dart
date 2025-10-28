import 'dart:io';

import 'package:busenet/src/enums/bn_cache_policy.dart';
import 'package:busenet/src/utility/typedefs.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'configuration/network_configuration.dart';
import 'dio/i_core_dio.dart';
import 'enums/http_types.dart';
import 'models/base_entity.dart';
import 'models/base_response.dart';

abstract class INetworkManager<T extends BaseResponse<T>> {
  ICoreDio get coreDio;
  Future<void> initialize(
    NetworkConfiguration configuration, {
    required T responseModel,
    String? entityKey,
    IOHttpClientAdapter? adapter,
  });

  Future<T> fetch<E extends BaseEntity<E>, R>(
    String path, {
    required E parserModel,
    required HttpTypes type,
    String contentType = Headers.jsonContentType,
    ResponseType responseType = ResponseType.json,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    BNCachePolicy cachePolicy = BNCachePolicy.noCache,
    Duration? maxStale,
    bool ignoreEntityKey = false,
    String? insideEntityKey,
  });

  Future<T> fetchPrimitive<E, R>(
    String path, {
    required HttpTypes type,
    String contentType = Headers.jsonContentType,
    ResponseType responseType = ResponseType.json,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    BNCachePolicy cachePolicy = BNCachePolicy.noCache,
    Duration? maxStale,
    bool ignoreEntityKey = false,
    String? insideEntityKey,
  });

  Future<File> downloadFile(
    String urlPath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    ProgressPercentageCallback? onReceiveProgressPercentage,
    CancelToken? cancelToken,
  });

  void addHeader(Map<String, dynamic> value);
  void addAuthorizationHeader(String token);
  void removeHeader(String key);
  void removeAuthorizationHeader();
  void cleanCache();
}
