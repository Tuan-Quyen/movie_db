import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_db/other/repository/repository_service_notification.dart';
import 'package:movie_db/screens/book_mark/book_mark_screen.dart';

import 'user_view_screen.dart';

class UserViewBloc {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = new FacebookLogin();
  final BehaviorSubject<MovieResponse> _subject = BehaviorSubject();
  final BehaviorSubject<UserModel> _user = BehaviorSubject();

  String _userID;

  BehaviorSubject<UserModel> get user => _user;

  String getTitleView(RowType rowType) {
    if (rowType == RowType.notifications) {
      return "Notifications";
    } else if (rowType == RowType.aboutUs) {
      return "About Us";
    } else if (rowType == RowType.version) {
      return "Version";
    }

    return "Logout";
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userID = await prefs.getString(Constant.USER_ID);
    print("user_id: $_userID");
    if (_userID != null) {
      var user = await UserManagement().getUser(_userID);
      _user.sink.add(user);
    }
  }

  // Action
  Future login(BuildContext context) async {
    if (_userID != null)
      await Navigator.of(context)
          .pushNamed(Constant.SCREEN_PROFILE)
          .then((value) {
        getUser();
      });
    else
      await Navigator.of(context)
          .pushNamed(Constant.SCREEN_LOGIN)
          .then((value) {
        getUser();
        BookMarkScreen.loadBookMark = true;
        BookMarkScreen.isLogin = true;
      });
  }

  void notifications(BuildContext context) {
    AppUtils().moveToScreen(context, Constant.SCREEN_NOTIFICATIONS, null, false);
  }

  void aboutUs(BuildContext context) {
    AppUtils().moveToScreen(context, Constant.SCREEN_ABOUT_US, null, false);
  }

  logout() async {
    _auth.signOut().then((value) async {
      _facebookLogin.logOut();
      _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(Constant.PASSWORD);
      prefs.remove(Constant.USER_ID).then((value) {
        _userID = null;
        _user.sink.add(null);
        BookMarkScreen.loadBookMark = true;
        BookMarkScreen.isLogin = false;
      });
    });
  }

  void checkOnTapAction(RowType rowType, BuildContext context) {
    if (rowType == RowType.notifications) {
      notifications(context);
    } else if (rowType == RowType.aboutUs) {
      aboutUs(context);
    } else if (rowType == RowType.logout) {
      logout();
    }
  }

  // Get All notification in database
  Future<int> getAllNotifications() async {
    return RepositoryServiceTodo.getAllNotifications().then((notifications) {
      return notifications.length;
    });
  }

  BehaviorSubject<MovieResponse> get subject => _subject;

  dispose() {
    _subject.close();
    _user.close();
  }
}
//final bloc = MovieBloc();
