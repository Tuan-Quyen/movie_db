import 'package:flutter/material.dart';
import 'package:movie_db/model/notification_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';

import 'notifications_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_NOTIFICATIONS;

  String title;

  NotificationsScreen({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationScreenState();
  }
}

class NotificationScreenState extends State<NotificationsScreen> {
  final bloc = NotificationsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getAllNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        context: context,
        fontSizeTitle: 20,
        titleAppBar: Constant.NOTIFICATIONS,
        isCenterTitle: true,
        hasLeft: true,
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: StreamBuilder(
                stream: bloc.notifications.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildNotificationWidget(snapshot.data);
                  } else {
                    return Container();
                  }
                }),
          ),
        ),
    );
  }

  Widget buildNotificationWidget(List<NotificationData> data) {
    List<NotificationData> notifications = data;
    notifications.reversed.toList();
    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, bottom: 5.0),
                  child: Text(
                    data[index].title,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                    textAlign: TextAlign.left,
                  )
                ),
                Text(
                  notifications[index].overview,
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  height: 0.5,
                  color: Colors.orange,
                  margin: EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          );
        });
  }
}
