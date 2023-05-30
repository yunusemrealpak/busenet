import 'dart:io';

import 'package:busenet/src/models/empty_response_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../enums/http_types.dart';
import '../models/base_entity.dart';
import '../models/base_response.dart';
import '../models/no_result_response.dart';
import '../utility/helper_functions.dart';
import 'i_core_dio.dart';

part '../parted_methods/model_parser.dart';

class CoreDio<T extends BaseResponse<T>> with DioMixin implements Dio, ICoreDio<T> {
  late CacheOptions cacheOptions;
  late T responseModel;
  String? entityKey;
  late bool isLoggerEnabled;

  CoreDio(
    BaseOptions options,
    this.cacheOptions,
    this.responseModel,
    this.entityKey, {
    this.isLoggerEnabled = true,
  }) {
    this.options = options;
    httpClientAdapter = IOHttpClientAdapter();
  }

  @override
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
  }) async {
    try {
      final response = await request<dynamic>(
        path,
        data: data,
        options: cacheOptions
            .copyWith(
              policy: cachePolicy,
              maxStale: Nullable<Duration>(maxStale),
            )
            .toOptions()
            .copyWith(
              method: type.value,
              contentType: contentType,
              responseType: responseType,
            ),
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      if (isLoggerEnabled) {
        customPrint(
          fromWhere: 'CoreDio',
          type: 'send - http statusCode',
          data: '${response.statusCode} - ${DateTime.now()}',
        );
      }

      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.accepted:
        case HttpStatus
              .notModified: // 304 : Cache Policy is used and data is not modified since last request (maxStale)

          final entity = _parseBody<E, R>(
            response.data,
            model: parserModel,
            entityKey: entityKey,
            insideEntityKey: insideEntityKey,
          );

          if (responseModel is! EmptyResponseModel) {
            responseModel = responseModel.fromJson(response.data as Map<String, dynamic>);
          }

          if (ignoreEntityKey) {
            responseModel.setData(response.data);
          } else {
            responseModel.setData(entity);
          }
          responseModel.statusCode = 1;

          return responseModel;
        // case 401:
        //   final model = ResponseModel.fromJson(response.data);
        // // await di<DialogService>()
        // //     .showDialog(message: model.errorMessage ?? '');
        // // return ResponseModel(statusCode: -1, data: {'message': ''});
        default:
          responseModel = responseModel.fromJson(response.data as Map<String, dynamic>);
          responseModel.statusCode = response.statusCode;
          return responseModel;
      }
    } catch (e) {
      responseModel.statusCode = -1;
      if (e is DioError) responseModel.errorMessage = e.message;
      return responseModel;
    }
  }

  @override
  void addHeader(Map<String, dynamic> value) {
    options.headers.addAll(value);
  }

  @override
  void removeHeader(String key) {
    options.headers.remove(key);
  }

  @override
  void addAuthorizationHeader(String token) {
    options.headers.addAll({'Authorization': 'Bearer $token'});
  }

  @override
  void removeAuthorizationHeader() {
    options.headers.remove('Authorization');
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    interceptors.add(interceptor);
  }
}
