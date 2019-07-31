import 'package:flutter/material.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin<SplashScreen> {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        value: 300, lowerBound: 0, upperBound: 300, vsync: this);
  }

  void fetchSomething() async {
    //TODO Call API from server and do sth
    await new Future.delayed(const Duration(seconds: 2)).then((value) {
      _controller
          .animateTo(0,
              curve: Curves.bounceInOut, duration: Duration(seconds: 1))
          .then((v) {
        AppUtils().moveToScreen(context, Constant.SCREEN_MAIN, null, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchSomething();
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: _controller.value,
            height: _controller.value,
            child: child,
          );
        },
        child: Container(
            child: Image.asset(
          "assets/images/img_splashscreen.png",
        )),
      ),
    );
  }
}
