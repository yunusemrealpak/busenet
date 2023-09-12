// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:busenet/busenet.dart';

final class EmptyResponseModel extends BaseResponse<EmptyResponseModel> {
  dynamic data;
  EmptyResponseModel({
    this.data,
  });

  @override
  EmptyResponseModel fromJson(Map<String, dynamic> json) {
    return EmptyResponseModel.fromMap(json);
  }

  @override
  void setData<R>(R entity) {
    data = entity;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
    };
  }

  factory EmptyResponseModel.fromMap(Map<String, dynamic> map) {
    return EmptyResponseModel(
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmptyResponseModel.fromJson(String source) => EmptyResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  EmptyResponseModel copyWith({
    dynamic data,
  }) {
    return EmptyResponseModel(
      data: data ?? this.data,
    );
  }

  @override
  void clearEntity() {
    data = null;
  }
}
