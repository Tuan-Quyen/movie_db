import 'package:flutter/material.dart';
import 'package:movie_db/interface/onclick_listener.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/password_inputfield_widget.dart';

import 'change_password_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_CHANGE_PASSWORD;

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordScreenState();
  }
}

class ChangePasswordScreenState extends State<ChangePasswordScreen>
    implements ConfirmListener {
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _confirmNewPasswordController = TextEditingController();
  var _focusNodeOldPasswod = FocusNode();
  var _focusNodeNewPassword = FocusNode();
  var _focusNodeconfirmNewPassword = FocusNode();
  ChangePasswordBloc bloc = ChangePasswordBloc();

  void onChange() {
    setState(() {});
  }

  @override
  void initState() {
    bloc.getUser();
    _focusNodeOldPasswod.addListener(onChange);
    _focusNodeNewPassword.addListener(onChange);
    _focusNodeconfirmNewPassword.addListener(onChange);
    super.initState();
  }

  void changePassword() {
    bloc.changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
        _confirmNewPasswordController.text,
        context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        titleAppBar: StringUtils.titleChangPasswordScreen,
        hasLeft: true,
        context: context,
        fontSizeTitle: 20,
        isCenterTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: Container(
            margin: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                PasswordInputFieldWidget(StringUtils.oldPassword,
                    _oldPasswordController, _focusNodeOldPasswod),
                PasswordInputFieldWidget(StringUtils.newPassword,
                    _newPasswordController, _focusNodeNewPassword),
                PasswordInputFieldWidget(
                    StringUtils.confirmNewPassword,
                    _confirmNewPasswordController,
                    _focusNodeconfirmNewPassword),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(5.0),
        width: double.infinity,
        color: ColorsUtils.orange,
        child: FlatButton(
          onPressed: () {
            changePassword();
          },
          child: Text(
            'Change',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onConfirmClick() {
    Navigator.pop(context);
  }
}
