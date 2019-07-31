import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:rxdart/rxdart.dart';

import 'more_movie_repository.dart';

class MoreMovieBloc {
  final MoreMovieRepository _moreMovieRepository = MoreMovieRepository();

  final BehaviorSubject<ResultMovie> _movie = BehaviorSubject();

  BehaviorSubject<ResultMovie> get movie => _movie;

  getMoviePopular(int page) async {
    MovieResponse response = await _moreMovieRepository.getMoviesPopular(page);
    if (response.error.isNotEmpty && response.movies == null) {
      _movie.addError(response.error);
      return DialogStateType.ERROR;
    } else {
      _movie.sink.add(response.movies);
    }
    return DialogStateType.SUCCESS;
  }

  dispose() {
    _movie.close();
  }
}
