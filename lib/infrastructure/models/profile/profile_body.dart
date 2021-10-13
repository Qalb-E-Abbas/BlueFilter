// To parse this JSON data, do
//
//     final profileBody = profileBodyFromJson(jsonString);

import 'dart:io';

class ProfileBody {
  ProfileBody({
    required this.name,
    required this.locale,
    required this.profile_image,
    required this.password,
    required this.phone,
    required this.longitude,
    required this.latitude,
    required this.bio,
    required this.notification,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.spotify,
    required this.profileCompleted,
    required this.address,
    required this.category_ids,
  });

  String name;
  String locale;
  String password;
  String phone;
  var longitude;
  var latitude;
  File? profile_image;
  String bio;
  String notification;
  String facebook;
  String instagram;
  String twitter;
  String spotify;
  String profileCompleted;
  String address;
  String category_ids;
}
