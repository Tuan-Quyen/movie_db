import 'package:flutter/material.dart';
import 'package:movie_db/interface/onclick_listener.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/screens/signup/sign_up_bloc.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/email_inputfield_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';
import 'package:movie_db/widgets/password_inputfield_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_SIGNUP;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen>
    implements ConfirmListener {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode _focusNodeconfirmPassword = FocusNode();
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  var bloc = SignUpBloc();

  void initState() {
    super.initState();
    _focusNodeEmail.addListener(onChange);
    _focusNodePassword.addListener(onChange);
    _focusNodeconfirmPassword.addListener(onChange);
  }

  void onChange() {
    setState(() {});
  }

  void signUpClick() {
    bloc.signUpWithEmailAndPassowd(_emailController.text,
        _passwordController.text, _confirmPasswordController.text, context);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        context: context,
        hasLeft: true,
        isCenterTitle: true,
        fontSizeTitle: 20,
        titleAppBar: Constant.SIGNUP,
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
                  EmailInputFieldWidget(_emailController, _focusNodeEmail),
                  PasswordInputFieldWidget(StringUtils.password,
                      _passwordController, _focusNodePassword),
                  PasswordInputFieldWidget(StringUtils.confirmPassword,
                      _confirmPasswordController, _focusNodeconfirmPassword),
                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            child: RaisedButton(
                              padding: EdgeInsets.all(20.0),
                              shape: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: ColorsUtils.orange)),
                              onPressed: () {
                                signUpClick();
                              },
                              color: ColorsUtils.orange,
                              child: Text(
                                StringUtils.signup,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: StreamBuilder(
                      stream: bloc.inProgress,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data)
                            return LoadWidget().buildLoadingWidget(context);
                        }
                        return new Container();
                      },
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
  void onConfirmClick() {
    // TODO: implement onConfirmClick
  }
}
