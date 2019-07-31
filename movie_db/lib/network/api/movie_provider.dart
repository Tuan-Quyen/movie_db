import 'package:dio/dio.dart';
import 'package:movie_db/app_config/app_config.dart';
import 'package:movie_db/model/caster_response.dart';
import 'package:movie_db/model/genres_response.dart';
import 'package:movie_db/model/movie_detail_response.dart';
import 'package:movie_db/model/result_add_watchlist_response.dart';
import 'package:movie_db/network/config/api_config.dart';
import 'package:movie_db/network/config/base_api.dart';
import 'package:movie_db/model/movie_response.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/model/video_model.dart';

class MovieProvider extends BaseApi {
  static String _apiKey =
      ApiConfig.createConnectionDetail(AppConfig.connectType).apiKey;

  Future<MovieResponse> getMoviesTopRated() async {
    String _url = "movie/top_rated?language=en-US&api_key=$_apiKey";
    try {
      Response response = await dio.get(_url);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMoviesPopular(int page) async {
    String _url = "movie/popular?language=en-US&api_key=$_apiKey";
    Map<String, String> queryMap = {ApiKeyParam.PAGE: page.toString()};
    try {
      Response response = await dio.get(_url, queryParameters: queryMap);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> searchMovie(String keyWord, int page) async {
    String _url = "search/movie?language=en-US&api_key=$_apiKey";
    Map<String, String> queryMap = {
      ApiKeyParam.SEARCH_KEYWORD_MOVIE: keyWord,
      ApiKeyParam.PAGE: page.toString()
    };
    try {
      Response response = await dio.get(_url, queryParameters: queryMap);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenresResponse> getGenres() async {
    String _url = "genre/movie/list?language=en-US&api_key=$_apiKey";
    try {
      Response response = await dio.get(_url);
      return GenresResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GenresResponse.withError("$error");
    }
  }

  Future<MovieDetailResponse> getMovieDetail(int movie_id) async {
    String _url = "movie/$movie_id?api_key=$_apiKey&language=en-US";
    try {
      Response response = await dio.get(_url);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<CasterResponse> getCaster(int movie_id) async {
    String _url = "movie/$movie_id/credits?api_key=$_apiKey";
    try {
      Response response = await dio.get(_url);
      return CasterResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CasterResponse.withError("$error");
    }
  }

  Future<ResultAddWatchListResponse> addMovieWatchList(int movie_id) async {
    String _url =
        "account/{account_id}/watchlist?api_key=$_apiKey&session_id=3d7d89a5a578de78539157b65748f29c49845898";
    Map<String, String> header = {
      'Content-Type': 'application/json;charset=utf-8'
    };
    dio.options.headers = header;
    try {
      Response response = await dio.post(_url, data: {
        "media_type": "movie",
        "media_id": "$movie_id",
        "watchlist": true
      });
      return ResultAddWatchListResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ResultAddWatchListResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieWatchlist(int page) async {
    String _url =
        "account/{account_id}/watchlist/movies?api_key=$_apiKey&language=en-US&session_id=${ApiKeyParam.SESSION_ID}&sort_by=created_at.asc&page=$page";
    try {
      Response response = await dio.get(_url);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<ResultAddWatchListResponse> removeMovieWatchList(int movie_id) async {
    String _url =
        "account/{account_id}/watchlist?api_key=$_apiKey&session_id=3d7d89a5a578de78539157b65748f29c49845898";
    Map<String, String> header = {
      'Content-Type': 'application/json;charset=utf-8'
    };
    dio.options.headers = header;
    try {
      Response response = await dio.post(_url, data: {
        "media_type": "movie",
        "media_id": "$movie_id",
        "watchlist": false
      });
      return ResultAddWatchListResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ResultAddWatchListResponse.withError("$error");
    }
  }

  Future<ResultGetListVideoResponse> getListVideo(int movie_id) async {
    String _url =
        "movie/$movie_id/videos?api_key=$_apiKey&language=en-US";

    try {
      Response response = await dio.get(_url);
      return ResultGetListVideoResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ResultGetListVideoResponse.withError("$error");
    }
  }

}
