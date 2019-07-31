class ResultMovie {
  int page;
  int totalResults;
  int totalPages;
  List<MovieModel> results;

  ResultMovie({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  factory ResultMovie.fromJson(Map<String, dynamic> json) => new ResultMovie(
    page: json["page"],
    totalResults: json["total_results"],
    totalPages: json["total_pages"],
    results: new List<MovieModel>.from(json["results"].map((x) => MovieModel.fromJson(x))),
  );
}

class MovieModel {
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

  MovieModel({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => new MovieModel(
    voteCount: json["vote_count"],
    id: json["id"],
    video: json["video"],
    voteAverage: json["vote_average"].toDouble(),
    title: json["title"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"] != null ? json["poster_path"] : "",
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    genreIds: new List<int>.from(json["genre_ids"].map((x) => x)),
    backdropPath: json["backdrop_path"],
    adult: json["adult"],
    overview: json["overview"],
    releaseDate: json["release_date"],
  );
}