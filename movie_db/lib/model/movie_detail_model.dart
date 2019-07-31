import 'genres_model.dart';
import 'genres_response.dart';

class MovieDetailModel {
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<GenreModel> genres;
  String backdropPath;
  int runtime;
  bool adult;
  String overview;
  String releaseDate;

  MovieDetailModel({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genres,
    this.runtime,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) => new MovieDetailModel(
    voteCount: json["vote_count"],
    id: json["id"],
    video: json["video"],
    voteAverage: json["vote_average"].toDouble(),
    title: json["title"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"] != null ? json["poster_path"] : "",
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    genres:new List<GenreModel>.from(json['genres'].map((x)=> GenreModel.fromJson(x))),
    backdropPath: json["backdrop_path"],
    adult: json["adult"],
    overview: json["overview"],
    releaseDate: json["release_date"],
    runtime: json['runtime'],
  );
}