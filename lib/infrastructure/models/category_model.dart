// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    this.data,
  });

  List<Datum>? data;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.color,
  });

  int? id;
  String? name;
  String? nameAr;
  String? color;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],
      name: json["name"],
      nameAr: json["name_ar"],
      color: json["color"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "name_ar": nameAr, "color": color};
}
