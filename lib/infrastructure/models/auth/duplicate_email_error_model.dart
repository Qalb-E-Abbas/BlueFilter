// To parse this JSON data, do
//
//     final duplicateEmailErrorModel = duplicateEmailErrorModelFromJson(jsonString);

import 'dart:convert';

DuplicateEmailErrorModel duplicateEmailErrorModelFromJson(String str) =>
    DuplicateEmailErrorModel.fromJson(json.decode(str));

String duplicateEmailErrorModelToJson(DuplicateEmailErrorModel data) =>
    json.encode(data.toJson());

class DuplicateEmailErrorModel {
  DuplicateEmailErrorModel({
    required this.success,
    required this.message,
    required this.errors,
  });

  bool success;
  String message;
  Errors errors;

  factory DuplicateEmailErrorModel.fromJson(Map<String, dynamic> json) =>
      DuplicateEmailErrorModel(
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
