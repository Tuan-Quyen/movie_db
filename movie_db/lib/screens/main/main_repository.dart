import 'package:movie_db/model/genres_response.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class MainRepository {
  MovieProvider _movieApi = MovieProvider();

  Future<GenresResponse> getGenres() {
    return _movieApi.getGenres();
  }
}