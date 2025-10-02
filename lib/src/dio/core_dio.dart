import 'dart:io';

import 'package:busenet/src/enums/bn_cache_policy.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart'
    hide BaseResponse;

import '../enums/http_types.dart';
import '../models/base_entity.dart';
import '../models/base_response.dart';
import '../models/empty_response_model.dart';
import '../models/failure/error_messages.dart';
import '../models/failure/failure.dart';
import '../models/no_result_response.dart';
import '../utility/helper_functions.dart';
import '../utility/typedefs.dart';
import 'i_core_dio.dart';

part '../parted_methods/error_handler.dart';
part '../parted_methods/model_parser.dart';

class CoreDio<T extends BaseResponse<T>> with DioMixin implements ICoreDio<T> {
  late CacheOptions cacheOptions;
  late T responseModel;
  String? entityKey;
  late bool isLoggerEnabled;
  late String downloadPath;

  ErrorMessages? errorMessages;

  CoreDio(BaseOptions options, this.cacheOptions, this.responseModel,
      this.entityKey, this.downloadPath,
      {this.isLoggerEnabled = true, this.errorMessages}) {
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
    BNCachePolicy? cachePolicy,
    Duration? maxStale,

    // Entity Options
    bool ignoreEntityKey = false,
    String? insideEntityKey,
  }) async {
    try {
      responseModel.clearResponse();

      final response = await request<dynamic>(
        path,
        data: data,
        options: cacheOptions
            .copyWith(
              policy: mapBNCachePolicyToDioCachePolicy(cachePolicy),
              maxStale: maxStale,
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
          data: '$path ${response.statusCode} - ${DateTime.now()}',
        );
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        final model = responseModel.fromJson(response.data);
        model.errorType = UnAuthorizedFailure(
            message: errorMessages?.unAuthorizedErrorMessage);
        return model;
      }

      if (response.statusCode == HttpStatus.notFound) {
        final model = responseModel.fromJson(response.data);
        model.errorType =
            NotFoundFailure(message: errorMessages?.notFoundErrorMessage);
        return model;
      }

      final entity = _parseBody<E, R>(
        response.data,
        model: parserModel,
        entityKey: entityKey,
        insideEntityKey: insideEntityKey,
        ignoreEntityKey: ignoreEntityKey,
      );

      if (responseModel is! EmptyResponseModel) {
        try {
          responseModel =
              responseModel.fromJson(response.data as Map<String, dynamic>);
        } catch (e) {
          responseModel = responseModel.fromJson({"$entityKey": {}});
        }
      }

      responseModel.setData(entity);
      // TODO: it will be removed
      responseModel.responseStatus = response.statusCode;
      responseModel.statusCode = 1;
      return responseModel;
    } catch (error) {
      responseModel.statusCode = -1;
      if (error is DioExceptionType) {
        responseModel.errorType = handleError(error, errorMessages);
      } else {
        responseModel.errorType = UnknownFailure(
            message: errorMessages?.unknownErrorMessage,
            dioError: error.toString());
      }
      return responseModel;
    }
  }

  @override
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
  }) async {
    try {
      final response = await request<dynamic>(
        path,
        data: data,
        options: cacheOptions
            .copyWith(
              policy: mapBNCachePolicyToDioCachePolicy(cachePolicy),
              maxStale: maxStale,
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

          final entity = _parseBodyPrimitive<E, R>(
            response.data,
            entityKey: entityKey,
            insideEntityKey: insideEntityKey,
          );

          if (responseModel is! EmptyResponseModel) {
            responseModel =
                responseModel.fromJson(response.data as Map<String, dynamic>);
          }

          if (ignoreEntityKey) {
            responseModel.setData(response.data);
          } else {
            responseModel.setData(entity);
          }
          responseModel.statusCode = 1;
          return responseModel;
        case 401:
          final model = responseModel.fromJson(response.data);
          model.errorType = UnAuthorizedFailure(
              message: errorMessages?.unAuthorizedErrorMessage);
          return model;
        case 404:
          final model = responseModel.fromJson(response.data);
          model.errorType =
              NotFoundFailure(message: errorMessages?.notFoundErrorMessage);
          return model;
        default:
          responseModel =
              responseModel.fromJson(response.data as Map<String, dynamic>);
          responseModel.statusCode = response.statusCode;
          return responseModel;
      }
    } catch (error) {
      responseModel.statusCode = -1;
      if (error is DioExceptionType) {
        responseModel.errorType = handleError(error, errorMessages);
      } else {
        responseModel.errorType = UnknownFailure();
      }
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

  @override
  Future<File> downloadFile(
    String urlPath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    ProgressPercentageCallback? onReceiveProgressPercentage,
    CancelToken? cancelToken,
  }) async {
    // find file extension from urlPath
    final list = urlPath.split('/');
    if (list.isEmpty) {
      throw Exception('File extension not found');
    }

    final fileName = list.last;

    final extension = fileName.split('.');
    if (extension.isEmpty) {
      throw Exception('File extension not found');
    }

    final filePath = "$downloadPath/$fileName";

    final response = await get(
      urlPath,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: Options(
        responseType: ResponseType.bytes,
      ),
      onReceiveProgress: (received, total) {
        if (onReceiveProgress != null) {
          onReceiveProgress(received, total);
          return;
        }

        onReceiveProgressPercentage
            ?.call(convertToPercentile(received / total));
      },
    );

    final file = File(filePath);
    var fs = file.openSync(mode: FileMode.write);
    fs.writeFromSync(response.data);

    await fs.close();

    return file;
  }
}
