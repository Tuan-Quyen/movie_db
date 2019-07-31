import 'package:flutter/material.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/model/screen_argument.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/screens/change_password/change_password_screen.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc {
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject();
  final BehaviorSubject<UserModel> _user = BehaviorSubject();
  final BehaviorSubject<String> _password = BehaviorSubject();
  String _userID = "";
  UserModel _userModel;

  BehaviorSubject<UserModel> get user => _user;

  BehaviorSubject<String> get password => _password;

  //get user from cloud firestore
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userID = await prefs.getString("user_id");
    print("user_id: $_userID");
    if (_userID != null) {
      _userModel = await UserManagement().getUser(_userID);
      _user.sink.add(_userModel);
    }
    String password = await SharePreference().getString(Constant.PASSWORD);
    _password.sink.add(password);
  }

  void moveToEditProfile(BuildContext context) async {
    await Navigator.of(context)
        .pushNamed(Constant.SCREEN_EDIT_PROFILE,
            arguments: ScreenArguments(message: _userModel))
        .then((value) {
      getUser();
    });
  }

  dispose() {
    _subject.close();
    _user.close();
    _password.close();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

  void moveToChangePassword(BuildContext context) {
    AppUtils()
        .moveToScreen(context, Constant.SCREEN_CHANGE_PASSWORD, null, false);
  }
}
