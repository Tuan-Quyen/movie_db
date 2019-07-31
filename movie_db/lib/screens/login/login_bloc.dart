import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/utils/validator_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginBloc {
  SharePreference sharePref;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin = new FacebookLogin();

  bool checkValid(String email, String password, BuildContext context) {
    String errorText = "";
    if (!Validator.isValidEmail(email)) {
      errorText = StringUtils.validEmail;
    } else if (password.length == 0) {
      errorText = StringUtils.loginFail;
    }
    if (errorText.isNotEmpty) {
      MessageDialog().information(context, "Error", errorText, null);
      return false;
    }
    return true;
  }

  loginLocal(String email, String password, BuildContext context) {
    if (checkValid(email, password, context)) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((FirebaseUser user) {
        SharePreference().setString(Constant.USER_ID, user.uid);
        SharePreference().setString(Constant.PASSWORD, password);
        Navigator.pop(context);
      }).catchError((e) {
        MessageDialog()
            .information(context, "Error", StringUtils.loginFail, null);
        print(e);
      });
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> firebaseAuthWithFacebook(
      {@required FacebookAccessToken token}) async {
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token.token);
    FirebaseUser firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return firebaseUser;
  }

  Future<FirebaseUser> _handlerLoginFacebook(BuildContext context) async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await _facebookLogin.logInWithReadPermissions(
      ['email', 'public_profile'],
    );
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await firebaseAuthWithFacebook(token: result.accessToken)
            .then((FirebaseUser user) {
          UserManagement().storeNewUser(user, context);
          SharePreference().setString(Constant.USER_ID, user.uid);
          Navigator.pop(context);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        // TODO: Handle this case.
        print(FacebookLoginStatus.error.toString());
        break;
    }
  }

  loginFacebook(BuildContext context) {
    _handlerLoginFacebook(context);
  }

  signGoogle(BuildContext context) {
    print("Sign in with Google");
    _handleSignIn().then((FirebaseUser user) {
      UserManagement().storeNewUser(user, context);
      SharePreference().setString(Constant.USER_ID, user.uid);
      Navigator.pop(context);
    });
  }

  void dispose() {}
}
