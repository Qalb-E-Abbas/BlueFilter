import 'dart:convert';
import 'dart:io';

import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/enums.dart';
import 'package:blue_filter/infrastructure/models/profile/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileServices {
  ///Update Profile Data
  Future<void> updateContactDetailsData(BuildContext context,
      {required ProfileBody model, required String authToken}) async {
    try {
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsBusy);
      var headers = {'Authorization': 'Bearer $authToken'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://www.bluefilter.ps/api/v1/update-profile'));
      request.fields.addAll({
        'name': model.name,
        'locale': model.locale,
        'password': model.password,
        'phone': model.phone,
        'latitude': model.latitude.toString(),
        'longitude': model.longitude.toString(),
        'bio': model.bio,
        'notification': model.notification,
        'facebook': model.facebook,
        'instagram': model.instagram,
        'twitter': model.twitter,
        'spotify': model.spotify,
        'profile_completed': model.profileCompleted,
        'address': model.address,
        'category_ids': model.category_ids
      });
      if (model.profile_image != null)
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', model.profile_image!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(await response.stream.bytesToString());
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsFree);
    } on HttpException catch (e) {
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(e.message);
      rethrow;
    }
  }

  ///Add Token
  Future<void> addToken(
    BuildContext context, {
    required String deviceToken,
    required String authToken,
  }) async {
    try {
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() +
              "add-token?device_token=$deviceToken"),
          headers: {
            'Authorization': 'Bearer $authToken',
          }).then((value) {
        print(value.body);
        if (value.statusCode == 200 || value.statusCode == 201) {
        } else {}
      });
    } on HttpException catch (e) {
      print(e.message);
      var data = jsonDecode(e.message.toString());
      print(data);
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      rethrow;
    }
  }

  ///Increment Counter
  Future<void> incrementCounter(BuildContext context,
      {required int id, required String authToken}) async {
    var map = new Map<String, dynamic>();
    map['id'] = id.toString();
    try {
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() + "count-click"),
          body: map,
          headers: {
            "contentType": "multipart/form-data",
            'Authorization': 'Bearer $authToken',
          }).then((value) {
        print(value.body);
        if (value.statusCode == 200 || value.statusCode == 201) {
          Provider.of<AppState>(context, listen: false)
              .stateStatus(AppCurrentState.IsFree);
        } else {
          Provider.of<AppState>(context, listen: false)
              .stateStatus(AppCurrentState.IsError);
        }
      });
    } on HttpException catch (e) {
      print(e.message);
      var data = jsonDecode(e.message.toString());
      print(data);
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      rethrow;
    }
  }
}
