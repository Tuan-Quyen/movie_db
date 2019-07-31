import 'package:flutter/material.dart';
import 'package:movie_db/interface/login_listener.dart';
import 'package:movie_db/model/type_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/custom_button_widget.dart';
import 'package:movie_db/widgets/email_inputfield_widget.dart';
import 'package:movie_db/widgets/password_inputfield_widget.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_LOGIN;

  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen>
    implements LoginOnClickListener {
  final bloc = LoginBloc();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();

  void onChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focusNodeEmail.addListener(onChange);
    _focusNodePassword.addListener(onChange);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        context: context,
        isCenterTitle: true,
        hasLeft: true,
        fontSizeTitle: 20,
        titleAppBar: Constant.LOGIN,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            margin: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                EmailInputFieldWidget(_emailController, _focusNodeEmail),
                PasswordInputFieldWidget(StringUtils.password,
                    _passwordController, _focusNodePassword),
                Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: <Widget>[
                      CustomButtonWidget(Type.loginLocal, this),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: new Text(
                          "or",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      CustomButtonWidget(Type.loginFacebook, this),
                      CustomButtonWidget(Type.loginGoogle, this),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                StringUtils.noAccount,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    StringUtils.creatAtOne,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      StringUtils.here,
                                      style: TextStyle(
                                          color: Colors.orange,
                                          decoration: TextDecoration.underline),
                                    ),
                                    onTap: () {
                                      AppUtils().moveToScreen(context,
                                          Constant.SCREEN_SIGNUP, null, false);
                                    },
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginClick(type) {
    switch (type) {
      case Type.loginLocal:
        bloc.loginLocal(
            _emailController.text, _passwordController.text, context);
        break;
      case Type.loginFacebook:
        bloc.loginFacebook(context);
        break;
      case Type.loginGoogle:
        bloc.signGoogle(context);
        break;
    }
  }
}
