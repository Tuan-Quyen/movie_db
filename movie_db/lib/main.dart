import 'package:flutter/material.dart';
import 'package:movie_db/screens/about_us/about_us_screen.dart';
import 'package:movie_db/screens/change_password/change_password_screen.dart';
import 'package:movie_db/screens/edit_profile/edit_profile_screen.dart';
import 'package:movie_db/screens/login/login_screen.dart';
import 'package:movie_db/screens/main/main_screen.dart';
import 'package:movie_db/screens/more_movie/more_movie_screen.dart';
import 'package:movie_db/screens/movie_detail/movie_detail_screen.dart';
import 'package:movie_db/screens/movie_video/movie_screen.dart';

import 'package:movie_db/screens/notifications/notification_screen.dart';
import 'package:movie_db/screens/profile/profile_screen.dart';
import 'package:movie_db/screens/search_movie/search_movie_screen.dart';
import 'package:movie_db/screens/signup/sign_up_screen.dart';
import 'package:movie_db/screens/splash/splash_screen.dart';
import 'package:movie_db/other/repository/database_creator.dart';

import 'model/screen_argument.dart';
import 'other/animation.dart';
import 'other/constant.dart';

void main() async {
  await DatabaseCreator().initDatabase();
  runApp(BaseApplication());
}

class BaseApplication extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      onGenerateRoute: (RouteSettings settings) {
        final ScreenArguments args = settings.arguments;
        switch (settings.name) {
          case Constant.SCREEN_ABOUT_US:
            return MaterialPageRoute(builder: (build) {
              return AboutUsScreen();
            });
            break;
          case Constant.SCREEN_CHANGE_PASSWORD:
            return SlideRightRoute(widget: ChangePasswordScreen());
            break;
          case Constant.SCREEN_MOVIE_DETAIL:
            return SlideRightRoute(
                widget: MovieDetailScreen(movieId: args.message,));
            break;
          case Constant.SCREEN_EDIT_PROFILE:
            return SlideRightRoute(
                widget: EditProfileScreen(
              userModel: args.message,
            ));
            break;
          case Constant.SCREEN_LOGIN:
            return SlideRightRoute(widget: LoginScreen());
            break;
          case Constant.SCREEN_MAIN:
            return MaterialPageRoute(builder: (build) {
              return MainScreen();
            });
            break;
          case Constant.SCREEN_MORE_VIDEOS_POPULAR:
            return SlideRightRoute(widget: MoreMovieScreen());
            break;
          case Constant.SCREEN_NOTIFICATIONS:
            return SlideRightRoute(widget: NotificationsScreen());
            break;
          case Constant.SCREEN_PROFILE:
            return SlideRightRoute(widget: ProfileScreen());
            break;
          case Constant.SCREEN_SEARCH_MOVIE:
            return SlideRightRoute(widget: SearchMovieScreen());
            break;
          case Constant.SCREEN_SIGNUP:
            return SlideRightRoute(widget: SignUpScreen());
            break;
          case Constant.SCREEN_MOVIE_VIDEO:
            return SlideRightRoute(
                widget: MovieVideoScreen(movieId: args.message));
            break;
        }
        return null;
      },
    );
  }
}
