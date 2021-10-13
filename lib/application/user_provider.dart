import 'package:blue_filter/infrastructure/models/user_short_modl.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserShortModel _loginHospital = UserShortModel();

  void saveLoginDetails(UserShortModel loginHospital) {
    _loginHospital = loginHospital;
    notifyListeners();
  }

  UserShortModel getLoginDetails() => _loginHospital;
}
