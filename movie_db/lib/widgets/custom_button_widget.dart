import 'package:flutter/material.dart';
import 'package:movie_db/interface/login_listener.dart';
import 'package:movie_db/model/type_model.dart';
import 'package:movie_db/utils/string_utils.dart';

class CustomButtonWidget extends StatelessWidget {
  LoginOnClickListener loginListener;
  Type type;

  CustomButtonWidget(this.type, this.loginListener);

  Color setColor() {
    if (type == Type.loginLocal)
      return Colors.orange;
    else if (type == Type.loginFacebook)
      return Colors.blueAccent;
    else
      return Colors.white;
  }

  String setText() {
    if (type == Type.loginLocal)
      return StringUtils.login;
    else if (type == Type.loginFacebook)
      return StringUtils.signinFB;
    else
      return StringUtils.signinGoogle;
  }

  Color setTextColor() {
    if (type == Type.loginLocal || type == Type.loginGoogle)
      return Colors.black;
    else if (type == Type.loginFacebook) return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        width: double.infinity,
        child: RaisedButton(
          padding: EdgeInsets.all(15.0),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          onPressed: () {
            loginListener.onLoginClick(type);
          },
          color: setColor(),
          child: Text(
            setText(),
            style: TextStyle(fontSize: 16.0, color: setTextColor()),
          ),
        ));
  }
}
