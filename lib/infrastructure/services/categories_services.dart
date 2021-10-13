import 'dart:convert';
import 'dart:io';

import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/enums.dart';
import 'package:blue_filter/infrastructure/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoriesServices {
  Future<CategoriesModel?> getCategories(BuildContext context,
      {required String authToken}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'GET', Uri.parse(BackendConfigs.apiUrlBuilder() + "categories"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.request);
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      }
      return CategoriesModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(e.message);
      rethrow;
    }
  }
}
