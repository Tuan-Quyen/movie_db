import 'movie_detail_model.dart';

class MovieDetailResponse{
  final MovieDetailModel movieDetail;
  final String error;

  MovieDetailResponse(this.movieDetail, this.error);
   MovieDetailResponse.fromJson(Map<String, dynamic> json)
      : movieDetail = MovieDetailModel.fromJson(json),
        error = "";
   MovieDetailResponse.withError(String errorValue)
      : movieDetail = null,
        error =errorValue;
}