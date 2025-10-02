import 'dart:io';

import 'package:busenet/src/enums/bn_cache_policy.dart';
import 'package:busenet/src/interceptors/logging_interceptor.dart';
import 'package:busenet/src/utility/typedefs.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart'
    hide BaseResponse;
import 'package:path_provider/path_provider.dart';

import 'configuration/network_configuration.dart';
import 'dio/core_dio.dart';
import 'dio/i_core_dio.dart';
import 'enums/http_types.dart';
import 'i_network_manager.dart';
import 'models/base_entity.dart';
import 'models/base_response.dart';

class NetworkManager<T extends BaseResponse<T>> implements INetworkManager<T> {
  late ICoreDio<T> dio;
  late T responseModel;
  late CacheStore cacheStore;

  @override
  Future<void> initialize(
    NetworkConfiguration configuration, {
    required T responseModel,
    String? entityKey,
  }) async {
    final baseOptions = BaseOptions(
      baseUrl: configuration.baseUrl,
      connectTimeout: configuration.connectTimeout,
      receiveTimeout: configuration.receiveTimeout,
      sendTimeout: configuration.sendTimeout,
      validateStatus: (status) {
        if (status == null) return false;
        return status < configuration.minimumValidateStatus;
      },
    );

    if (configuration.apiKey != null) {
      baseOptions.headers['apiKey'] = configuration.apiKey;
    }

    final dirr = await getTemporaryDirectory();

    // Download Directory
    String downloadPath = configuration.downloadPath ?? dirr.path;
    if (downloadPath.endsWith('/')) {
      downloadPath = downloadPath.substring(0, downloadPath.length - 1);
    }
    final downloadFolderPath = '$downloadPath/${configuration.downloadFolder}';
    final exists = await Directory(downloadFolderPath).exists();
    if (!exists) {
      await Directory(downloadFolderPath).create(recursive: true);
    }

    cacheStore = MemCacheStore();

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.noCache,
      priority: CachePriority.high,
      maxStale: const Duration(minutes: 1),
      hitCacheOnErrorCodes: [500],
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    );

    dio = CoreDio<T>(
      baseOptions,
      cacheOptions,
      responseModel,
      entityKey,
      downloadFolderPath,
      errorMessages: configuration.errorMessages,
      isLoggerEnabled: configuration.isLoggerEnabled,
    )
      ..addInterceptor(DioCacheInterceptor(options: cacheOptions))
      ..addInterceptor(
          LoggingInterceptor(isLoggerEnabled: configuration.isLoggerEnabled));
  }

  @override
  ICoreDio<T> get coreDio => dio;

  @override
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
  }) async {
    return await coreDio.send<E, R>(
      path,
      parserModel: parserModel,
      type: type,
      cachePolicy: cachePolicy,
      cancelToken: cancelToken,
      contentType: contentType,
      data: data,
      maxStale: maxStale,
      onSendProgress: onSendProgress,
      queryParameters: queryParameters,
      responseType: responseType,
      ignoreEntityKey: ignoreEntityKey,
      insideEntityKey: insideEntityKey,
    );
  }

  @override
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
  }) async {
    return await coreDio.sendPrimitive<E, R>(
      path,
      type: type,
      cachePolicy: cachePolicy,
      cancelToken: cancelToken,
      contentType: contentType,
      data: data,
      maxStale: maxStale,
      onSendProgress: onSendProgress,
      queryParameters: queryParameters,
      responseType: responseType,
      ignoreEntityKey: ignoreEntityKey,
      insideEntityKey: insideEntityKey,
    );
  }

  @override
  Future<File> downloadFile(
    String urlPath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    ProgressPercentageCallback? onReceiveProgressPercentage,
    CancelToken? cancelToken,
  }) {
    return coreDio.downloadFile(
      urlPath,
      onReceiveProgress: onReceiveProgress,
      onReceiveProgressPercentage: onReceiveProgressPercentage,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  @override
  void addHeader(Map<String, dynamic> value) {
    coreDio.addHeader(value);
  }

  @override
  void addAuthorizationHeader(String token) {
    coreDio.removeAuthorizationHeader();
    coreDio.addAuthorizationHeader(token);
  }

  @override
  void removeHeader(String key) {
    coreDio.removeHeader(key);
  }

  @override
  void removeAuthorizationHeader() {
    coreDio.removeAuthorizationHeader();
  }

  @override
  Future<void> cleanCache() async {
    await cacheStore.clean();
  }
}
