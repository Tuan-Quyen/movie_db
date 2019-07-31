import 'movie_model.dart';

class MovieResponse {
  final ResultMovie movies;
  final String error;

  MovieResponse(this.movies, this.error);

  MovieResponse.fromJson(Map<String, dynamic> json)
      : movies = ResultMovie.fromJson(json),
        error = "";

  MovieResponse.withError(String errorValue)
      : movies = null,
        error = errorValue;
}
