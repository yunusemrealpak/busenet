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
  busenet: ^0.1.5
```

### Usage

#### Import the package

```dart
import 'package:busenet/busenet.dart';
```

#### Create a new Network Manager instance

İki farklı proje için iki farklı response model örneği oluşturuyorum. İki modelimiz de BaseResponse dan miras almak zorunda.

BaseResponse
```dart
abstract class BaseResponse<T> {
  int? statusCode;

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

Şimdi bir instance oluşturalım. İki model için dataların set edileceği yerin property adını entityKey'e ekliyoruz. 


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

#### Make a  request

```dart
...
final response = await manager.coreDio.send<SamplePostModel, SamplePostModel>(
      '${NetworkPaths.getSamplePost}/1',
      parserModel: const SamplePostModel(),
      type: HttpTypes.get,
      cachePolicy: CachePolicy.forceCache, // optional - defaults to CachePolicy.noCache
      maxStale: const Duration(seconds: 10), // optional - defaults to 10 seconds if cachePolicy is CachePolicy.forceCache
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