import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class MoreMovieRepository {
  MovieProvider _movieApi = MovieProvider();

  Future<MovieResponse> getMoviesPopular(int page) {
    return _movieApi.getMoviesPopular(page);
  }
}
