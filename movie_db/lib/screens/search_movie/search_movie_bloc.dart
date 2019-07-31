import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/screens/search_movie/search_movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchMovieBloc {
  final SearchMovieRepository _searchMovieRepository = SearchMovieRepository();
  final BehaviorSubject<SearchMovieType> _typeMovie = BehaviorSubject();

  BehaviorSubject<SearchMovieType> get typeMovie => _typeMovie;
  final BehaviorSubject<ResultMovie> _searchMovie = BehaviorSubject();

  BehaviorSubject<ResultMovie> get searchMovie => _searchMovie;

  searchKeyWordMovie(String keyWord, int page) async {
    if (keyWord.isNotEmpty) {
      MovieResponse response = await _searchMovieRepository.SearchKeyWordMovie(
          keyWord.trim().toLowerCase(), page);
      if (response.error.isNotEmpty && response.movies == null) {
        _searchMovie.addError(response.error);
        return DialogStateType.ERROR;
      } else {
        _searchMovie.sink.add(response.movies);
      }
    } else {
      _searchMovie.sink.add(new ResultMovie(results: []));
    }
    return DialogStateType.SUCCESS;
  }

  selectMovieType() {
    _typeMovie.sink.add(SearchMovieType.MOVIE);
  }

  selectCastType() {
    _typeMovie.sink.add(SearchMovieType.CAST);
  }

  dispose() {
    _typeMovie.close();
  }
}
