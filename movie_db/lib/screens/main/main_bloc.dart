import 'package:movie_db/model/genres_response.dart';
import 'package:movie_db/model/global_model.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:rxdart/rxdart.dart';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movie_db/model/notification_model.dart';
import 'package:movie_db/other/repository/repository_service_notification.dart';
import 'main_repository.dart';
import 'dart:io';

class MainBloc {
  final MainRepository _mainRepository = MainRepository();
  final BehaviorSubject<int> _index = BehaviorSubject();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  selectPage(int index) {
    _index.sink.add(index);
  }

  getGenres() async {
    GenresResponse response = await _mainRepository.getGenres();
    SharePreference().getWatchListMovie().then((value) {
      if (value != null) GlobalModel.listIdBookMark = value;
    });
    GlobalModel.listGenres = response.genres;
  }

  dispose() {
    _index.close();
  }

  BehaviorSubject<int> get index => _index;

  // Setup Push Notification

  void iOS_Permission() {

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }
  }

  // Handle Listeners Push Notification
  void fireBaseCloudMessagingListeners() {

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(

      onMessage: (Map<String, dynamic> message) async {
        print('Message $message');
        parseDataNotification(message);
      },

      onResume: (Map<String, dynamic> message) async {
        print('Message $message');
        parseDataNotification(message);
      },

      onLaunch: (Map<String, dynamic> message) async {
        print('Message $message');
        parseDataNotification(message);
      },

    );
  }

  void ontapBannerNotification(Map<String, dynamic> message) {
    parseDataNotification(message);
  }

  void parseDataNotification(Map<String, dynamic> message) async {
    int count = await RepositoryServiceTodo.notificationsCount();
    if (Platform.isIOS) {
      var iOSData = NotificationIOS.fromJson(message);
      var notiData = NotificationData.storeData(count,
          iOSData.title, iOSData.overview,
          iOSData.aps.badge);
      createTodo(notiData);
    } else {
      var notiAndroidData = NotificationAndroid.fromJson(message);
      var notiData = NotificationData.storeData(count,
          notiAndroidData.data.title, notiAndroidData.data.overview,
          int.tryParse(notiAndroidData.data.badge));
      createTodo(notiData);
    }
  }

  void createTodo(NotificationData notificationData) async {
    final notification = notificationData;
    await RepositoryServiceTodo.addNotification(notification);
    print(notification.id);
  }


}

