import 'package:flutter/cupertino.dart';

class UserType extends ChangeNotifier {
  String _userType = "";

  void saveUserType(String userType) {
    _userType = userType;
    notifyListeners();
  }

  String getUserType() => _userType;
}
