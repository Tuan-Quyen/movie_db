import 'package:movie_db/model/caster_response.dart';
import 'package:movie_db/model/movie_detail_response.dart';
import 'package:movie_db/model/result_add_watchlist_response.dart';

import 'package:movie_db/network/api/movie_provider.dart';
class MovieDetailRepoisitory{
  MovieProvider _movieApi = MovieProvider();
  Future<MovieDetailResponse> getMovieDetail(int movie_id){
    return _movieApi.getMovieDetail(movie_id);
  }
  Future<CasterResponse> getCasters(int movie_id){
    return _movieApi.getCaster(movie_id);
  }
  Future<ResultAddWatchListResponse> addWathList(int movie_id){
    return _movieApi.addMovieWatchList(movie_id);
  }
}