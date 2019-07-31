import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/interface/onclick_listener.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/utils/validator_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordBloc {
  BehaviorSubject<UserModel> _user = BehaviorSubject();
  String _password = "";
  UserModel _userModel;

  Future getUser() async {
    _password = await SharePreference().getString(Constant.PASSWORD);
    print("password: " + _password);
    String user_id = await SharePreference().getString(Constant.USER_ID);
    print("user_id: $user_id");
    if (user_id != null) {
      _userModel = await UserManagement().getUser(user_id);
      _user.sink.add(_userModel);
    }
  }

  bool checkValid(
    String oldPassword,
    String newPassword,
    String confirmNewPassword,
    BuildContext context,
  ) {
    String errorText = "";

    if (oldPassword != _password) {
      errorText = StringUtils.validOldPassword;
    } else if (!Validator.isValidPassword(newPassword)) {
      errorText = StringUtils.validPassword;
    } else if (!Validator.isValidConfirmPassword(
        confirmNewPassword, newPassword)) {
      errorText = StringUtils.validConfirmNewsPassword;
    }
    if (errorText.isNotEmpty) {
      MessageDialog().information(context, StringUtils.error, errorText, null);
      return false;
    }
    return true;
  }

  changePassword(
      String oldPassword,
      String newPassword,
      String confirmNewPassword,
      BuildContext context) async {
    if (checkValid(oldPassword, newPassword, confirmNewPassword, context)) {
      FirebaseAuth _auth = await FirebaseAuth.instance;
      await _auth.currentUser().then((value) async {
        print(value.email);
        AuthCredential credential = EmailAuthProvider.getCredential(
            email: value.email, password: _password);
        value.reauthenticateWithCredential(credential).then((value) {
          value.updatePassword(newPassword).then((value) async {
            await SharePreference()
                .setString(newPassword, Constant.PASSWORD);
            MessageDialog()
                .information(context, "", StringUtils.change_success, null);
          }).catchError((e) {
            MessageDialog()
                .information(context, "", StringUtils.change_fail, null);
            print(e);
          });
        }).catchError((e){
          MessageDialog()
              .information(context, "", StringUtils.isIncorrect, null);
          print(e);
        });
      });
    }
  }

  dispose() {
    _user.close();
  }
}
