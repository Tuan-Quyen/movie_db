import 'package:flutter/cupertino.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/utils/validator_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpBloc {
  BehaviorSubject<bool> _inProgress = BehaviorSubject();

  bool checkValid(String email, String password, String confirmPassword,
      BuildContext context) {
    String errorText = "";
    if (!Validator.isValidEmail(email)) {
      errorText = StringUtils.validEmail;
    } else if (!Validator.isValidPassword(password)) {
      errorText = StringUtils.validPassword;
    } else if (!Validator.isValidConfirmPassword(confirmPassword, password)) {
      errorText = StringUtils.validConfirmPassword;
    }
    if (errorText.isNotEmpty) {
      MessageDialog().information(context, StringUtils.error, errorText, null);
      return false;
    }
    return true;
  }

  signUpWithEmailAndPassowd(String email, String password,
      String confirmPassword, BuildContext context) {
    _inProgress.sink.add(true);
    if (checkValid(email, password, confirmPassword, context)) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((signedInUser) {
        UserManagement().storeNewUser(signedInUser, context);
        _inProgress.sink.add(false);
        Navigator.of(context).pop();
      }).catchError((e) {
        MessageDialog().information(
            context, StringUtils.error, StringUtils.emailtIsExist, null);
        _inProgress.sink.add(false);
        print(e);
      });
    } else {
      MessageDialog().information(
          context, StringUtils.error, StringUtils.signUpFail, null);
      _inProgress.add(false);
    }
  }

  BehaviorSubject<bool> get inProgress => _inProgress;

  void dispose() {
    _inProgress.close();
  }
}
