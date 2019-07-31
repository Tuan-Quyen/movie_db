
import 'package:movie_db/model/video_model.dart';
import 'package:movie_db/network/api/movie_provider.dart';

class MovieVideoRepository {

  MovieProvider _movieApi = MovieProvider();

  Future<ResultGetListVideoResponse> getListVideo(int movie_id){
    return _movieApi.getListVideo(movie_id);
  }

}