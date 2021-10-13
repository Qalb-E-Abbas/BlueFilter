// To parse this JSON data, do
//
//     final emailPwdValidationErrorModel = emailPwdValidationErrorModelFromJson(jsonString);

import 'dart:convert';

EmailPwdValidationErrorModel emailPwdValidationErrorModelFromJson(String str) =>
    EmailPwdValidationErrorModel.fromJson(json.decode(str));

String emailPwdValidationErrorModelToJson(EmailPwdValidationErrorModel data) =>
    json.encode(data.toJson());

class EmailPwdValidationErrorModel {
  EmailPwdValidationErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  bool success;
  String message;
  Errors errors;

  factory EmailPwdValidationErrorModel.fromJson(Map<String, dynamic> json) =>
      EmailPwdValidationErrorModel(
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
    required this.email,
  });

  List<String> email;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        email: List<String>.from(json["email"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "email": List<dynamic>.from(email.map((x) => x)),
      };
}
