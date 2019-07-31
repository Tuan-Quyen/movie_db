import 'package:email_validator/email_validator.dart';

mixin Validator {
  static bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  static bool isValidPassword(String password) {
    return password.length > 8;
  }

  static bool isValidConfirmPassword(String confirm_password, String password) {
    return confirm_password == password;
  }
}
