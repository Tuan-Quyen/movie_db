import 'package:flutter/material.dart';
import 'package:movie_db/model/genres_model.dart';
import 'package:movie_db/model/global_model.dart';
import 'package:movie_db/model/screen_argument.dart';

class AppUtils {
  List<GenreModel> listGenres(List<int> _listGenresId) {
    List<GenreModel> _list = [];
    for (int i = 0; i < _listGenresId.length; i++) {
      for (int j = 0; j < GlobalModel.listGenres.length; j++) {
        if (_listGenresId[i] == GlobalModel.listGenres[j].id) {
          _list.add(GlobalModel.listGenres[j]);
        }
      }
    }
    return _list;
  }

  void moveToScreen(
      BuildContext context, String routeName, var message, bool replace) async {
    if (replace) {
      Navigator.pushReplacementNamed(context, routeName,
          arguments: ScreenArguments(message: message));
    } else {
      Navigator.pushNamed(context, routeName,
          arguments: ScreenArguments(message: message));
    }
  }

//  void _moveToScreenWithBackData(BuildContext context, String routeName, String message) async {
//    Navigator.pushNamed(context, routeName,
//        arguments: ScreenArguments(message: message)
//    ).then((text){
//      setState(() {
//        textReturn = text != null ? text : "";
//      });
//    });
//  }

}
