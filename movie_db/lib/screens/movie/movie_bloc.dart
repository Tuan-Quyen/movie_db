import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movie_db/model/notification_model.dart';
import 'package:movie_db/other/repository/repository_service_notification.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'movie_repository.dart';
import 'dart:io';

class MovieBloc {
  final MovieRepository _movieRepository = MovieRepository();

  final BehaviorSubject<List<MovieModel>> _movieTopRate = BehaviorSubject();

  BehaviorSubject<List<MovieModel>> get movieTopRate => _movieTopRate;
  final BehaviorSubject<List<MovieModel>> _moviePopular = BehaviorSubject();

  BehaviorSubject<List<MovieModel>> get moviePopular => _moviePopular;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  getMovieTopRate() async {
    MovieResponse response = await _movieRepository.getMoviesTopRated();
    if (response.error.isNotEmpty && response.movies == null) {
      _movieTopRate.addError(response.error);
      return DialogStateType.ERROR;
    } else {
      _movieTopRate.sink.add(response.movies.results);
    }
    return DialogStateType.SUCCESS;
  }

  getMoviePopular() async {
    MovieResponse response = await _movieRepository.getMoviesPopular();
    if (response.error.isNotEmpty && response.movies == null) {
      _moviePopular.addError(response.error);
      return DialogStateType.ERROR;
    } else {
      _moviePopular.sink.add(response.movies.results);
    }
    return DialogStateType.SUCCESS;
  }

  /*selectBookMark(int position) {
    if (AppUtils().isBookMark(_listPopular[position].id)) {
      for (int i = 0; i < GlobalModel.listIdBookMark.length; i++) {
        if (_listPopular[position].id == GlobalModel.listIdBookMark[i]) {
          GlobalModel.listBookMarkMovie.removeAt(i);
          GlobalModel.listIdBookMark.removeAt(i);
        }
      }
    } else {
      GlobalModel.listBookMarkMovie.add(_listPopular[position]);
      GlobalModel.listIdBookMark.add(_listPopular[position].id);
    }
    _moviePopular.sink.add(_listPopular);
  }*/

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

  dispose() async {
    await _movieTopRate.drain();
    _movieTopRate.close();
    await _moviePopular.drain();
    _moviePopular.close();
  }
}
