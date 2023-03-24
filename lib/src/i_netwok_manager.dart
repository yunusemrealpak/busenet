import 'package:busbus/busbus.dart';

abstract class INetworkManager<T extends BaseResponse<T>> {
  ICoreDio get coreDio;
  void initialize(
    NetworkConfiguration configuration, {
    required T responseModel,
    String? entityKey,
  });

  void addHeader(Map<String, dynamic> value);
  void addAuthorizationHeader(String token);
  void removeHeader(String key);
  void removeAuthorizationHeader();
  void cleanCache();
}
