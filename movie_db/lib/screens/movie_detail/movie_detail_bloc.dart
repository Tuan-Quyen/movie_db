import 'package:movie_db/model/caster_model.dart';
import 'package:movie_db/model/caster_response.dart';
import 'package:movie_db/model/global_model.dart';
import 'package:movie_db/model/movie_detail_model.dart';
import 'package:movie_db/model/movie_detail_response.dart';
import 'package:movie_db/model/result_add_watchlist_response.dart';
import 'package:movie_db/other/share_preference.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/screens/book_mark/book_mark_screen.dart';
import 'package:rxdart/rxdart.dart';

import 'movie_detail_repository.dart';

class MovieDetailBloc {
  final MovieDetailRepoisitory _movieRepoisitory = MovieDetailRepoisitory();

  final BehaviorSubject<MovieDetailModel> _movieDetail = BehaviorSubject();

  BehaviorSubject<MovieDetailModel> get movieDetail => _movieDetail;

  final BehaviorSubject<List<CasterModel>> _caster = BehaviorSubject();

  BehaviorSubject<List<CasterModel>> get caster => _caster;

  final BehaviorSubject<bool> _resultAddWatchList = BehaviorSubject();

  BehaviorSubject<bool> get resultAddWatchList => _resultAddWatchList;

  getMovieDetail(int idMovie) async {
    MovieDetailResponse movieDetailResponse =
        await _movieRepoisitory.getMovieDetail(idMovie);
    if (movieDetailResponse.error.isNotEmpty &&
        movieDetailResponse.movieDetail == null) {
      _movieDetail.sink.addError(movieDetailResponse.error);
      return DialogStateType.ERROR;
    } else {
      _movieDetail.sink.add(movieDetailResponse.movieDetail);
    }
    return DialogStateType.SUCCESS;
  }

  getCasters(int idMovie) async {
    CasterResponse casterRespons = await _movieRepoisitory.getCasters(idMovie);
    if (casterRespons.error.isNotEmpty && casterRespons.casters == null) {
      _caster.sink.addError(casterRespons.error);
      return DialogStateType.ERROR;
    } else {
      _caster.sink.add(casterRespons.casters);
      return DialogStateType.SUCCESS;
    }
  }

  addWatchList(int idMovie) async {
    _resultAddWatchList.sink.add(true);
    ResultAddWatchListResponse response =
        await _movieRepoisitory.addWathList(idMovie);
    if (response.error.isNotEmpty && response.resultAddWatchListModel == null) {
      _resultAddWatchList.sink.add(false);
      return DialogStateType.ERROR;
    } else {
      if (response.resultAddWatchListModel.statusCode == 1) {
        _resultAddWatchList.sink.add(true);
        GlobalModel.listIdBookMark.add(idMovie.toString());
        SharePreference().saveWatchListMovie(GlobalModel.listIdBookMark);
        BookMarkScreen.loadBookMark = true;
      } else if (response.resultAddWatchListModel.statusCode == 12) {
        _resultAddWatchList.sink.add(true);
        return DialogStateType.ADDEDBOOKMARK;
      } else {
        _resultAddWatchList.sink.add(false);
      }
    }
    return DialogStateType.SUCCESS;
  }

  String formatDurationTime(int time) {
    if (time <= 60) {
      return time.toString() + "m";
    } else {
      int hours = (time / 60).round();
      int seconds = time % 60;
      return hours.toString() + "h " + seconds.toString() + "m";
    }
  }

  bool isBookMark(int idMovie) {
    for (int i = 0; i < GlobalModel.listIdBookMark.length; i++) {
      if (idMovie.toString() == GlobalModel.listIdBookMark[i]) {
        return true;
      }
    }
    return false;
  }

  dispose() {
    _movieDetail.close();
    _caster.close();
  }
}
