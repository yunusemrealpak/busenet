abstract class BaseResponse<T> {
  int? statusCode;
  String? errorMessage;

  T fromJson(Map<String, dynamic> json);
  void setData<R>(R entity);
}
