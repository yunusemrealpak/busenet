This package is a custom network layer for Flutter that leverages the popular Dio HTTP client library to manage API requests. It provides a generic response model and supports optional request-based caching. The caching feature reduces unnecessary network traffic and improves application performance when the same API request is made multiple times.

With this package, you can easily manage your application's network layer and develop faster, more efficient applications.

## Features

-   Generic response model
-   Request-based caching
-   Customizable request headers, query parameters, and request body, including support for multipart file uploads.

## Getting Started

### Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  busenet: ^0.6.3
```

### Usage

#### Import the package

```dart
import 'package:busenet/busenet.dart';
```

#### Create a new Network Manager instance

Let's create two different response model examples for two different projects. Both of our models must inherit from BaseResponse.

BaseResponse
```dart
abstract class BaseResponse<T> {
  int? statusCode;
  String? errorMessage;
  Failure? errorType;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);
}
```

FirstResponseModel
```dart
class FirstResponseModel extends BaseResponse<FirstResponseModel> {
  dynamic entity;
  dynamic error;
  bool? success;
  String? message;

  ResponseModel({
    this.entity,
    this.error,
    this.success,
    this.message,
  });

  @override
  void setData<R>(R entity) {
    this.entity = entity;
  }

  @override
  ResponseModel fromJson(Map<String, dynamic> json) {
    return ResponseModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entity': entity,
      'error': error,
      'success': success,
      'message': message,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      entity: map['entity'] as dynamic,
      error: map['error'] as dynamic,
      success: map['success'] != null ? map['success'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) => ResponseModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
```

SecondResponseModel
```dart
class SecondResponseModel extends BaseResponse<SecondResponseModel> {
  dynamic body;
  // int? statusCode; already exists in the class it inherits

  SecondResponseModel({
    required this.body,
  });

  @override
  SecondResponseModel fromJson(Map<String, dynamic> json) {
    return SecondResponseModel.fromMap(json);
  }

  @override
  void setData<R>(R entity) {
    body = entity;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
    };
  }

  factory SecondResponseModel.fromMap(Map<String, dynamic> map) {
    return SecondResponseModel(
      body: map['body'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory SecondResponseModel.fromJson(String source) =>
      SecondResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
```

Let's create an instance now. We are adding the property name where the data will be set for both models to entityKey.

```dart
...
INetworkManager manager = NetworkManager<FirstResponseModel>()
        ..initialize(
          NetworkConfiguration('<base-url>'),
          responseModel: FirstResponseModel(),
          cacheStoreKey: 'boilerplate_cache',
          entityKey: 'entity',
        );
...

or

...
INetworkManager manager = NetworkManager<SecondResponseModel>()
        ..initialize(
          NetworkConfiguration('<base-url>'),
          responseModel: SecondResponseModel(),
          cacheStoreKey: 'boilerplate_cache',
          entityKey: 'body',
        );
...
```

###### Important Note:

If you don't have a custom response model architecture for your project, you can create an instance using EmptyResponseModel. Please take a look at the example project.

```dart
,,,
INetworkManager manager = NetworkManager<EmptyResponseModel>()
      ..initialize(
        NetworkConfiguration('<base-url>'),
        responseModel: EmptyResponseModel(),
        cacheStoreKey: 'example-cache',
      );
...
```

#### Make a  request

```dart
...
final response = await manager.fetch<SamplePostModel, SamplePostModel>(
      '${NetworkPaths.getSamplePost}/1',
      parserModel: const SamplePostModel(),
      type: HttpTypes.get,
      cachePolicy: CachePolicy.forceCache, // optional - defaults to CachePolicy.noCache
      maxStale: const Duration(seconds: 10), // optional - defaults to 10 seconds if cachePolicy is CachePolicy.forceCache
      ignoreEntityKey: true, // optional - defaults to false  -> if true, the data will not be set to the entityKey property of the response model
    ) as SampleResponseModel;

    switch (response.statusCode) {
      case 1:
        return response.data as SamplePostModel;
      default:
        return null;
    }
...
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/yunusemrealpak/busenet/blob/main/LICENSE) file for details