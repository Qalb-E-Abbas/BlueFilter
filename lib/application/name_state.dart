import 'package:shared_preferences/shared_preferences.dart';

class UserNameState {
  static String sharedPreferenceUserName = "USERNAME";
  static String sharedPreferenceEmail = "EMAIL";

  /// saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserName, name);
  }

  /// fetching data from sharedpreference
  static Future<String?> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserName);
  }

  static Future<bool> saveUserEmailSharedPreference(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceEmail, email);
  }

  /// fetching data from sharedpreference
  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceEmail);
  }

  static String _image = "image";

  /// saving data to sharedpreference
  static Future<bool> saveImage(String image) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_image, image);
  }

  /// fetching data from sharedpreference
  static Future<String?> getImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(_image);
  }
}
