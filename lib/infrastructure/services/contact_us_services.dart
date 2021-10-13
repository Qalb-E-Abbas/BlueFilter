import 'dart:io';

import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ContactUsServices {
  ///User SignUp
  Future contactUs(
    BuildContext context, {
    required String subject,
    required String message,
    required String authToken,
  }) async {
    var formData = {
      'subject': subject,
      'message': message,
    };
    try {
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsBusy);
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() + "contact"),
          body: formData,
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
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(e.message);
      Provider.of<AppState>(context, listen: false)
          .stateStatus(AppCurrentState.IsError);
      rethrow;
    }
  }
}
