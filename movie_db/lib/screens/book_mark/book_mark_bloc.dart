import 'package:movie_db/model/global_model.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/model/result_add_watchlist_response.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movie_db/model/user_mangement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book_mark_respository.dart';

class BookMarkBloc {
  final BehaviorSubject<ResultMovie> _movieWatchlist = BehaviorSubject();
  final BookMarkRespostory _movieRepository = BookMarkRespostory();

  BehaviorSubject<ResultMovie> get movie => _movieWatchlist;

  String _userID;

  Future<bool> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userID = await prefs.getString(Constant.USER_ID);
    print("user_id: $_userID");
    if (_userID != null) {
      return true;
    }

    return false;
  }

  getMovieWatchList(int _page) async {
    MovieResponse movieResponse =
        await _movieRepository.getMovieWatchList(_page);
    if (movieResponse.error.isNotEmpty && movieResponse.movies == null) {
      _movieWatchlist.addError(movieResponse.error);
      return DialogStateType.ERROR;
    } else {
      _movieWatchlist.sink.add(movieResponse.movies);
    }
    return DialogStateType.SUCCESS;
  }

  removeMovieWatchList(MovieModel movie) async {
    ResultAddWatchListResponse response =
        await _movieRepository.removeMovieWatchList(movie.id);
    if (response.error.isNotEmpty && response.resultAddWatchListModel == null) {
      _movieWatchlist.addError(response.error);
      return DialogStateType.ERROR;
    } else {
      if (response.resultAddWatchListModel.statusCode == 13) {
        GlobalModel.listIdBookMark.remove(movie.id.toString());
        SharePreference().saveWatchListMovie(GlobalModel.listIdBookMark).then(
            (value) => _movieWatchlist.sink.add(ResultMovie(results: null)));
      }
    }
    return DialogStateType.SUCCESS;
  }

  dispose() {
    _movieWatchlist.close();
  }
}
