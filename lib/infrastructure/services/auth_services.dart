import 'dart:convert';
import 'dart:io';

import 'package:blue_filter/application/errorStrings.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/email_pwd_error_model.dart';
import 'package:blue_filter/infrastructure/models/auth/password_reset_model.dart';
import 'package:blue_filter/infrastructure/models/auth/success_registration_model.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

enum AuthState { UnInit, Authenticating, Authenticated, UnAuthenticated }

class AuthServices extends ChangeNotifier {
  AuthState _authState = AuthState.UnInit;

  SuccessfulLoginModel? _loginUserModel;

  ///It will use to set the login State
  void setState(AuthState status) {
    _authState = status;
    notifyListeners();
  }

  SuccessfulLoginModel? get user => _loginUserModel;

  ///It will give the current user login State
  AuthState get status => _authState;

  ///User Login
  Future<SuccessfulLoginModel?> loginUser(BuildContext context,
      {required String email,
      required String password,
      required String type}) async {
    print(type);
    print(email);
    print(password);
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;
    map['type'] = type;
    try {
      setState(AuthState.Authenticating);
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() + "login"),
          body: map,
          headers: {"contentType": "multipart/form-data"}).then((value) {
        print(value.body);
        if (value.statusCode == 200 || value.statusCode == 201) {
          setState(AuthState.Authenticated);
          _loginUserModel =
              SuccessfulLoginModel.fromJson(json.decode(value.body));
          return SuccessfulLoginModel.fromJson(json.decode(value.body));
        } else if (value.statusCode == 404 || value.statusCode == 401) {
          var data = json.decode(value.body);
          print(data);
          Provider.of<ErrorString>(context, listen: false)
              .saveErrorString(data['message']);
          setState(AuthState.UnAuthenticated);
        } else {
          Provider.of<ErrorString>(context, listen: false)
              .saveErrorString("An undefined error occurred");
          setState(AuthState.UnAuthenticated);
        }
      });
    } on HttpException catch (e) {
      print(e.message);
      var data = jsonDecode(e.message.toString());
      print(data);
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(data['reasonPhrase']);
      setState(AuthState.UnAuthenticated);
      rethrow;
    }
  }

  ///User SignUp
  Future<SuccessRegistrationModel?> signUpUser(BuildContext context,
      {required String type,
      required String email,
      required String name,
      required String password}) async {
    _authState = AuthState.Authenticating;

    notifyListeners();
    var formData = {
      'type': type,
      'name': name,
      'email': email,
      'password': password,
    };
    try {
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() + "register"),
          body: formData,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }).then((value) {
        SuccessRegistrationModel _successRegistrationModel;
        print(value.body);
        if (value.statusCode == 200 || value.statusCode == 201) {
          setState(AuthState.Authenticated);
          _successRegistrationModel =
              SuccessRegistrationModel.fromJson(json.decode(value.body));
          return _successRegistrationModel;
        } else {
          EmailPwdValidationErrorModel model =
              EmailPwdValidationErrorModel.fromJson(json.decode(value.body));

          Provider.of<ErrorString>(context, listen: false)
              .saveErrorString(model.errors.email[0]);
          setState(AuthState.UnAuthenticated);
        }
      });
    } on HttpException catch (e) {
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(e.message);
      setState(AuthState.UnAuthenticated);
      rethrow;
    }
  }

  ///Forgot Password
  Future<PasswordResetModel?> resetPassword(
    BuildContext context, {
    required String type,
    required String email,
  }) async {
    
    print("From Forgot Pwd : $type");
    _authState = AuthState.Authenticating;

    notifyListeners();
    var formData = {
      'type': type,
      'email': email,
    };
    try {
      return await http.post(
          Uri.parse(BackendConfigs.apiUrlBuilder() + "send-new-password"),
          body: formData,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }).then((value) {
        PasswordResetModel _successPasswordModel;
        print(value.body);
        if (value.statusCode == 200 || value.statusCode == 201) {
          setState(AuthState.Authenticated);
          _successPasswordModel =
              PasswordResetModel.fromJson(json.decode(value.body));
          return _successPasswordModel;
        } else {
          PasswordResetModel model =
              PasswordResetModel.fromJson(json.decode(value.body));

          Provider.of<ErrorString>(context, listen: false)
              .saveErrorString(model.message);
          setState(AuthState.UnAuthenticated);
        }
      });
    } on HttpException catch (e) {
      Provider.of<ErrorString>(context, listen: false)
          .saveErrorString(e.message);
      setState(AuthState.UnAuthenticated);
      rethrow;
    }
  }
}
