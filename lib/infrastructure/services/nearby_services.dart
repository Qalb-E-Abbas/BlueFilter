import 'dart:convert';
import 'dart:io';

import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/enums.dart';
import 'package:blue_filter/infrastructure/models/nearby_service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NearByServiceProviderServices {
  ///Get Posts
  Future<NearbyServiceModel> getNearbyServiceProvider(BuildContext context,
      {required String authToken, required int pageNo}) async {
    try {
      var headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              BackendConfigs.apiUrlBuilder() + "nearby-service-providers"));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.request);
      var model;
      if (response.statusCode == 200 || response.statusCode == 201) {
        model = await response.stream.bytesToString();
      }
      return NearbyServiceModel.fromJson(json.decode(model));
    } on HttpException catch (e) {
      print(e.message);
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      var data = jsonDecode(e.message.toString());

      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      rethrow;
    }
  }
}
