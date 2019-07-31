import 'genres_model.dart';

class GenresResponse {
  final List<GenreModel> genres;
  final String error;

  GenresResponse(this.genres, this.error);

  GenresResponse.fromJson(Map<String, dynamic> json)
      : genres = (json["genres"] as List)
            .map((i) => new GenreModel.fromJson(i))
            .toList(),
        error = "";

  GenresResponse.withError(String errorValue)
      : genres = [],
        error = errorValue;
}
