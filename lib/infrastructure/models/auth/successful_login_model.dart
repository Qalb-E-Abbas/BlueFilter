// To parse this JSON data, do
//
//     final successfulLoginModel = successfulLoginModelFromJson(jsonString);

import 'dart:convert';

SuccessfulLoginModel successfulLoginModelFromJson(String str) =>
    SuccessfulLoginModel.fromJson(json.decode(str));

String successfulLoginModelToJson(SuccessfulLoginModel data) =>
    json.encode(data.toJson());

class SuccessfulLoginModel {
  SuccessfulLoginModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory SuccessfulLoginModel.fromJson(Map<String, dynamic> json) =>
      SuccessfulLoginModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    required this.locale,
    required this.profileCompleted,
    this.isApproved,
    required this.category,
    required this.profileImage,
    required this.profileThumbnail,
    required this.phone,
    required this.longitude,
    required this.latitude,
    required this.bio,
    required this.notification,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.spotify,
    required this.address,
    required this.distance,
    required this.service_provider_clicks,
  });

  int id;
  String email;
  dynamic name;
  String type;
  String locale;
  String profileCompleted;
  String? isApproved;
  List<dynamic> category;
  dynamic profileImage;
  dynamic profileThumbnail;
  dynamic phone;
  dynamic longitude;
  dynamic latitude;
  dynamic bio;
  String notification;
  dynamic facebook;
  dynamic instagram;
  dynamic twitter;
  dynamic spotify;
  dynamic address;
  dynamic distance;
  int service_provider_clicks;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        type: json["type"],
        locale: json["locale"],
        profileCompleted: json["profile_completed"],
        isApproved: json["is_approved"],
        category: List<dynamic>.from(
          json["category"].map<dynamic>(
            (dynamic item) => json["category"],
          ),
        ),
        profileImage: json["profile_image"],
        profileThumbnail: json["profile_thumbnail"],
        phone: json["phone"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        bio: json["bio"],
        notification: json["notification"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        twitter: json["twitter"],
        spotify: json["spotify"],
        address: json["address"],
        distance: json["distance"],
        service_provider_clicks: json["service_provider_clicks"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "type": type,
        "locale": locale,
        "profile_completed": profileCompleted,
        "is_approved": isApproved,
        "category": List<dynamic>.from(category.map((x) => x)),
        "profile_image": profileImage,
        "profile_thumbnail": profileThumbnail,
        "phone": phone,
        "longitude": longitude,
        "latitude": latitude,
        "bio": bio,
        "notification": notification,
        "facebook": facebook,
        "instagram": instagram,
        "twitter": twitter,
        "spotify": spotify,
        "address": address,
        "distance": distance,
        "service_provider_clicks": service_provider_clicks,
      };
}

class Category {
  int? id;
  String? name;
  String? nameAr;
  String? color;

  Category({this.id, this.name, this.nameAr, this.color});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['color'] = this.color;
    return data;
  }
}
