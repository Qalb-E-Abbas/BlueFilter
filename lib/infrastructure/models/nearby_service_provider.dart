// To parse this JSON data, do
//
//     final nearbyServiceModel = nearbyServiceModelFromJson(jsonString);

import 'dart:convert';

NearbyServiceModel nearbyServiceModelFromJson(String str) =>
    NearbyServiceModel.fromJson(json.decode(str));

String nearbyServiceModelToJson(NearbyServiceModel data) =>
    json.encode(data.toJson());

class NearbyServiceModel {
  NearbyServiceModel({
    this.data,
    this.links,
    this.meta,
  });

  List<Datum>? data;
  Links? links;
  Meta? meta;

  factory NearbyServiceModel.fromJson(Map<String, dynamic> json) =>
      NearbyServiceModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links!.toJson(),
        "meta": meta!.toJson(),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    required this.locale,
    required this.profileCompleted,
    required this.isApproved,
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
  });

  var id;
  String email;
  String name;
  String type;
  String locale;
  String profileCompleted;
  String isApproved;
  List<dynamic> category;
  var profileImage;
  var profileThumbnail;
  String phone;
  String longitude;
  String latitude;
  String bio;
  String notification;
  var facebook;
  var instagram;
  var twitter;
  var spotify;
  String address;
  var distance;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        type: json["type"],
        locale: json["locale"],
        profileCompleted: json["profile_completed"],
        isApproved: json["is_approved"],
        category: List<dynamic>.from(json["category"].map((x) => x)),
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
        profileThumbnail: json["profile_thumbnail"] == null
            ? null
            : json["profile_thumbnail"],
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
        "profile_image": profileImage == null ? null : profileImage,
        "profile_thumbnail": profileThumbnail == null ? null : profileThumbnail,
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
      };
}

class Links {
  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  var currentPage;
  var from;
  var lastPage;
  List<Link> links;
  String path;
  var perPage;
  var to;
  var total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  var url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
