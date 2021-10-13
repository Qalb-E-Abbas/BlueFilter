import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTypeProvider extends ChangeNotifier {
  final String key = "userType";
  SharedPreferences? _pref;
  String _userType = "";

  String get getUserType => _userType;

  UserTypeProvider() {
    _userType = "hi";
    _loadFromPrefs();
  }

  saveUserType(String? userType) {
    print("Save user type called");
    _userType = userType!;

    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _userType = _pref!.getString(key) ?? "";
    print("From State Provider : $_userType");
    notifyListeners();
  }

  _saveToPrefs() async {
    print("From Save to Pref : $_userType");
    await _initPrefs();
    _pref!.setString(key, _userType);
  }
}
