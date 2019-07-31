import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/screens/profile/profile_bloc.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_PROFILE;

  @override
  _StateProfileScreen createState() => _StateProfileScreen();
}

class _StateProfileScreen extends State<ProfileScreen> {
  final bloc = ProfileBloc();

  @override
  void initState() {
    bloc.getUser();
    super.initState();
  }

  Container imageProfile(String ImageUrl) {
    return Container(
      height: 250,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Center(
        child: new Container(
          width: 130.0,
          height: 130.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: ImageUrl != null
                  ? AdvancedNetworkImage(
                      ImageUrl,
                      fallbackAssetImage: "assets/images/ic_caster_failed.png",
                    )
                  : AssetImage("assets/images/ic_caster_failed.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(65.0)),
            border: new Border.all(
              color: Color.fromRGBO(255, 156, 0, 1),
              width: 4.0,
            ),
          ),
        ),
      ),
    );
  }

  Padding lineView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        color: Colors.grey,
        height: 0.5,
      ),
    );
  }

  Container textTitle(String string) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0, top: 20, left: 20, right: 20),
      child: Text(
        string,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Color.fromRGBO(255, 156, 0, 1),
          fontSize: 13,
        ),
      ),
    );
  }

  Container textDataProfile(String string) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Text(
        string != null ? string : "",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Container changePassword() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: FlatButton(
        padding: const EdgeInsets.only(bottom: 8),
        onPressed: () => ontapChangePasswordButton(),
        child: Text(
          'Change password',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color.fromRGBO(255, 156, 0, 1),
          ),
        ),
      ),
    );
  }

  void ontapChangePasswordButton() {
    bloc.moveToChangePassword(context);
  }

  void ontapEditButton() {
    bloc.moveToEditProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        context: context,
        titleAppBar: Constant.PROFILE,
        isCenterTitle: true,
        hasLeft: true,
        fontSizeTitle: 20,
        actionWidget: <Widget>[
          StreamBuilder(
              stream: bloc.password.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return FlatButton(
                    onPressed: () => ontapEditButton(),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(255, 156, 0, 1),
                      ),
                    ),
                  );
                return new Container();
              })
        ],
      ),
      body: SafeArea(
          child: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder(
            stream: bloc.user.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageProfile(snapshot.data.profileImage),
                    textTitle('Fullname'),
                    textDataProfile(snapshot.data.userName),
                    lineView(),
                    textTitle('Email'),
                    textDataProfile(snapshot.data.email),
                    lineView(),
                    StreamBuilder(
                        stream: bloc.password.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) return changePassword();
                          return new Container();
                        })
                  ],
                );
              }
              return LoadWidget().buildLoadingWidget(context);
            }),
      )),
    );
  }
}
