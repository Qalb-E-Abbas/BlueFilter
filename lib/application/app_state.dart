import 'package:blue_filter/configuration/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  AppCurrentState _status = AppCurrentState.IsFree;

  void stateStatus(AppCurrentState status) {
    _status = status;
    notifyListeners();
  }

  getStateStatus() => _status;
}
