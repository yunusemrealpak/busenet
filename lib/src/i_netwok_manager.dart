import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'configuration/network_configuration.dart';
import 'dio/i_core_dio.dart';
import 'enums/http_types.dart';
import 'models/base_entity.dart';
import 'models/base_response.dart';

abstract class INetworkManager<T extends BaseResponse<T>> {
  ICoreDio get coreDio;
  void initialize(
    NetworkConfiguration configuration, {
    required T responseModel,
    String? entityKey,
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
    CachePolicy cachePolicy = CachePolicy.forceCache,
    Duration maxStale = const Duration(minutes: 1),
  });

  void addHeader(Map<String, dynamic> value);
  void addAuthorizationHeader(String token);
  void removeHeader(String key);
  void removeAuthorizationHeader();
  void cleanCache();
}
