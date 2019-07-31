import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class MovieRepository {
  MovieProvider _movieApi = MovieProvider();

  Future<MovieResponse> getMoviesTopRated() {
    return _movieApi.getMoviesTopRated();
  }

  Future<MovieResponse> getMoviesPopular() {
    return _movieApi.getMoviesPopular(1);
  }
}
