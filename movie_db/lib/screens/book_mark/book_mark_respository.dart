import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/model/result_add_watchlist_response.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class BookMarkRespostory{
  MovieProvider _movieApi = MovieProvider();
  Future<MovieResponse> getMovieWatchList(int page){
    return _movieApi.getMovieWatchlist(page);
  }

  Future<ResultAddWatchListResponse> removeMovieWatchList(int movie_id){
    return _movieApi.removeMovieWatchList(movie_id);
  }
}