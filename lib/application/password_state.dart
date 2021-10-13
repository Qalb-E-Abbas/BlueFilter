import 'package:shared_preferences/shared_preferences.dart';

class PasswordState {
  static String sharedPreferencePassword = "PASSWORD";

  /// saving data to sharedpreference
  static Future<bool> saveUserPasswordSharedPreference(String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferencePassword, password);
  }

  /// fetching data from sharedpreference
  static Future<String?> getPasswordSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferencePassword);
  }
}
