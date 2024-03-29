part of '../dio/core_dio.dart';

R? _parseBody<T extends BaseEntity<T>, R>(
  dynamic responseBody, {
  required T model,
  String? entityKey,
  String? insideEntityKey,
  bool ignoreEntityKey = false,
}) {
  if (R is NoResultResponse || R == NoResultResponse) {
    return NoResultResponse() as R;
  }

  dynamic data = responseBody;

  if (entityKey != null && !ignoreEntityKey) {
    data = responseBody[entityKey];
  }

  if (data != null && insideEntityKey != null) {
    data = data[insideEntityKey];
  }

  if (data == null) {
    customPrint(
      fromWhere: 'Network Layer',
      type: '_parseBody',
      data: 'Be careful your data $data, Cannot be null',
    );
    return null;
  }

  try {
    if (data is List) {
      return data.map((data) => model.fromJson(data)).cast<T>().toList() as R;
    } else if (data is Map<String, dynamic>) {
      return model.fromJson(data) as R;
    } else {
      customPrint(
        fromWhere: 'Network Layer',
        type: '_parseBody',
        data: 'Be careful your data $data, I could not parse it',
      );
      return null;
    }
  } catch (e) {
    customPrint(
      fromWhere: 'Network Layer',
      type: '_parseBody',
      data: 'Parse Error: $e - response body: $data T model: $T , R model: $R ',
    );
  }
  return null;
}

R? _parseBodyPrimitive<T, R>(
  dynamic responseBody, {
  String? entityKey,
  String? insideEntityKey,
}) {
  dynamic data = responseBody;

  if (entityKey != null) {
    data = responseBody[entityKey];
  }

  if (entityKey != null && insideEntityKey != null) {
    data = data[insideEntityKey];
  }

  if (data == null) {
    customPrint(
      fromWhere: 'Network Layer',
      type: '_parseBody',
      data: 'Be careful your data $data, Cannot be null',
    );
    return null;
  }

  try {
    if (data is List) {
      return data.map((data) => data as T).cast<T>().toList() as R;
    }

    return data as R?;
  } catch (e) {
    customPrint(
      fromWhere: 'Network Layer',
      type: '_parseBody',
      data: 'Parse Error: $e - response body: $data T model primitive: $T',
    );
  }
  return null;
}
