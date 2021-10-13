import 'package:validated/validated.dart' as validate;

class ValidationHandler {
  static validateInput({required String returnString, String? inputValue}) {
    if (inputValue!.isEmpty) {
      return returnString;
    } else if (!validate.isEmail(inputValue)) {
      return "Kindly enter valid email";
    } else {
      return null;
    }
  }

  static validatePassword(
      {required String errorString,
      required String shortPassword,
      String? inputValue}) {
    if (inputValue!.isEmpty) {
      return errorString;
    } else if (inputValue.length < 8) {
      return shortPassword;
    } else {
      return null;
    }
  }
}
