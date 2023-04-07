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
  busenet: ^0.1.4
```

### Usage

#### Import the package

```dart
import 'package:busenet/busenet.dart';
```

#### Create a new Network Manager instance

```dart
...
INetworkManager manager = NetworkManager<SampleResponseModel>()
        ..initialize(
          NetworkConfiguration('<base-url>'),
          responseModel: SampleResponseModel(),
          cacheStoreKey: 'boilerplate_cache',
          entityKey: 'body', // optional - defaults to 'body' || 'data' || 'result'
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