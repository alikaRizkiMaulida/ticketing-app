import 'dart:convert';

class LikeResponseModel {
  final String status;
  final String message;

  LikeResponseModel({
    required this.status,
    required this.message,
  });

  factory LikeResponseModel.fromJson(String str) =>
      LikeResponseModel.fromMap(json.decode(str));

  factory LikeResponseModel.fromMap(Map<String, dynamic> json) =>
      LikeResponseModel(
        status: json["status"] ?? '',
        message: json["message"] ?? '',
      );
}
