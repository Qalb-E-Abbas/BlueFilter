// To parse this JSON data, do
//
//     final passwordResetModel = passwordResetModelFromJson(jsonString);

import 'dart:convert';

PasswordResetModel passwordResetModelFromJson(String str) =>
    PasswordResetModel.fromJson(json.decode(str));

String passwordResetModelToJson(PasswordResetModel data) =>
    json.encode(data.toJson());

class PasswordResetModel {
  PasswordResetModel({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory PasswordResetModel.fromJson(Map<String, dynamic> json) =>
      PasswordResetModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
