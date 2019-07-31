import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/model/user_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/widgets/load_widget.dart';

import 'user_view_bloc.dart';

enum RowType { notifications, aboutUs, version, logout }

class UserViewScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_USER_VIEW;

  const UserViewScreen();

  @override
  _StateUserViewScreen createState() => _StateUserViewScreen();
}

class _StateUserViewScreen extends State<UserViewScreen>
    with AutomaticKeepAliveClientMixin<UserViewScreen> {
  //
  final bloc = UserViewBloc();

  // The header view will show when user still login
  bool visibilityUserView = false;

  // This is badge number to show hide text icon in Notification row.
  int badgeNumber = 0;

  // State Widget Life Cycle.
  @override
  void initState() {
    bloc.getUser();
    bloc.getAllNotifications().then((value) {
      badgeNumber = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    // other dispose methods
    super.dispose();
  }

  Container headerView(UserModel userModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: new Row(
        children: <Widget>[
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    userModel == null
                        ? "Hi, Guest"
                        : "Hi, ${userModel.userName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                new InkWell(
                  onTap: () => ontapViewProfileButton(),
                  child: SizedBox(
                    child: Container(
                      child: Text(
                        userModel != null
                            ? 'View profile'
                            : 'Login/Sign up to see more options',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: userModel != null
                              ? Color.fromRGBO(255, 156, 0, 1)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          userModel != null
              ? imageProfile(userModel.profileImage)
              : new Container(),
        ],
      ),
    );
  }

  Container imageProfile(String imageUrl) {
    return new Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Center(
          child: imageUrl != null
              ? new Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: new AdvancedNetworkImage(imageUrl,
                          fallbackAssetImage:
                              "assets/images/ic_caster_failed.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(40.0)),
                    border: new Border.all(
                      color: Color.fromRGBO(255, 156, 0, 1),
                      width: 2.0,
                    ),
                  ),
                )
              : new Container(
                  width: 80.0,
                  height: 80.0,
                )),
    );
  }

  // Line View
  Padding lineView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
      child: Container(
        color: Colors.grey,
        height: 0.5,
      ),
    );
  }

  Padding rowView(RowType rowType) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 22),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => bloc.checkOnTapAction(rowType, context),
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  bloc.getTitleView(rowType),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              new Container(
                width: (rowType == RowType.version) ? 60 : 28.0,
                height: 28.0,
                decoration: (rowType == RowType.notifications)
                    ? new BoxDecoration(
                        color: badgeNumber > 0
                            ? Color.fromRGBO(255, 156, 0, 1)
                            : Color.fromRGBO(0, 0, 0, 1),
                        borderRadius: new BorderRadius.circular(14.0),
                      )
                    : new BoxDecoration(),
                child: new Center(
                    child: (rowType == RowType.notifications)
                        ? new Text(
                            badgeNumber > 0 ? '$badgeNumber' : '',
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.white),
                          )
                        : (rowType == RowType.version)
                            ? new Text(
                                Constant.VERSION,
                                style: new TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0,
                                    color: Colors.white),
                              )
                            : new Container()),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Action Screen
  void ontapViewProfileButton() {
    bloc.login(context);
  }

  Column bodyRow(UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        headerView(userModel),
        rowView(RowType.notifications),
        lineView(),
        rowView(RowType.aboutUs),
        lineView(),
        rowView(RowType.version),
        lineView(),
        userModel != null
            ? rowView(RowType.logout)
            : new Container(),
        userModel != null ? lineView() : new Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.black,
          )),
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: StreamBuilder(
            stream: bloc.user.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return bodyRow(snapshot.data);
              } else if (snapshot.hasError) {
                return LoadWidget().buildErrorWidget(snapshot.error, context);
              } else {
                LoadWidget().buildLoadingWidget(context);
                return bodyRow(snapshot.data);
              }
            }),
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
