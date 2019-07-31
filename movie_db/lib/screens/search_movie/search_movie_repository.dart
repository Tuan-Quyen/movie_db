import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class SearchMovieRepository {
  MovieProvider _movieApi = MovieProvider();

  Future<MovieResponse> SearchKeyWordMovie(String keyWord, int page) {
    return _movieApi.searchMovie(keyWord, page);
  }
}