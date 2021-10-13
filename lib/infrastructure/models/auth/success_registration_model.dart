class SuccessRegistrationModel {
  SuccessRegistrationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  Data data;

  factory SuccessRegistrationModel.fromJson(Map<String, dynamic> json) =>
      SuccessRegistrationModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        type: json["type"],
        locale: json["locale"],
        profileCompleted: json["profile_completed"],
        isApproved: json["is_approved"],
        category: List<dynamic>.from(json["category"].map((x) => x)),
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
      };
}
