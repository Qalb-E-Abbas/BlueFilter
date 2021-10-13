// To parse this JSON data, do
//
//     final passwordErrorModel = passwordErrorModelFromJson(jsonString);

import 'dart:convert';

PasswordErrorModel passwordErrorModelFromJson(String str) =>
    PasswordErrorModel.fromJson(json.decode(str));

String passwordErrorModelToJson(PasswordErrorModel data) =>
    json.encode(data.toJson());

class PasswordErrorModel {
  PasswordErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  bool success;
  String message;
  Errors errors;

  factory PasswordErrorModel.fromJson(Map<String, dynamic> json) =>
      PasswordErrorModel(
        success: json["success"],
        message: json["message"],
        errors: Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errors": errors.toJson(),
      };
}

class Errors {
  Errors({
    required this.password,
  });

  List<String> password;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        password: List<String>.from(json["password"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "password": List<dynamic>.from(password.map((x) => x)),
      };
}
