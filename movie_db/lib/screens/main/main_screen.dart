import 'package:flutter/material.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/screens/book_mark/book_mark_screen.dart';
import 'package:movie_db/screens/movie/movie_screen.dart';
import 'package:movie_db/screens/user_view/user_view_screen.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/item_bottom_bar_widget.dart';
import 'package:movie_db/screens/maps/maps_screen.dart';
import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_MAIN;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final bloc = MainBloc();
  TabController _controller;

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: _list().length, vsync: this);
    bloc.getGenres();
//    bloc.fireBaseCloudMessagingListeners();
  }

  List<Widget> _list() {
    return [
      MovieScreen(),
      BookMarkScreen(),
      MapMovieTheater(),
      UserViewScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.index.stream,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: ColorsUtils.black,
            body: IndexedStack(
              children: _list(),
              index: snapshot.data != null ? snapshot.data : 0,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: ColorsUtils.black_bottom,
              items: <BottomNavigationBarItem>[
                ItemBottomBar(normalIcon: Icons.home, pressedIcon: Icons.home),
                ItemBottomBar(
                    normalIcon: Icons.bookmark_border,
                    pressedIcon: Icons.bookmark),
                ItemBottomBar(
                    normalIcon: Icons.location_on,
                    pressedIcon: Icons.location_on),
                ItemBottomBar(
                    normalIcon: Icons.view_headline,
                    pressedIcon: Icons.view_headline),
              ],
              onTap: (index) {
                bloc.selectPage(index);
                _controller.animateTo(index);
              },
              currentIndex: snapshot.data != null ? snapshot.data : 0,
            ),
          );
        });
  }
}
