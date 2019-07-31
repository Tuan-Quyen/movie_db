import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

class SharePreference {
  SharedPreferences _preferences;

  Future saveWatchListMovie(List<String> value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setStringList(Constant.WATCHLIST_MOVIE, value);
  }

  Future<List<String>> getWatchListMovie() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getStringList(Constant.WATCHLIST_MOVIE);
  }

  Future setString(String name, String value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setString(name, value);
  }

  Future<String> getString(String name) async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getString(name);
  }

  Future clearAllPreference() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }
}
