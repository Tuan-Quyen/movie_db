
import 'package:movie_db/other/type_enum.dart';

import 'movie_video_repository.dart';
import 'package:movie_db/model/video_model.dart';

import 'package:rxdart/rxdart.dart';

class MovieVideoBloc {
  final MovieVideoRepository _videosRepository = MovieVideoRepository();
  final List<Video> _listVideo = [];
  final BehaviorSubject<List<Video>> _videos = BehaviorSubject();

  BehaviorSubject<List<Video>> get videos => _videos;

  getMovieTopRate(int movieId) async {
    ResultGetListVideoResponse response = await _videosRepository.getListVideo(movieId);
    if (response.error.isNotEmpty && response.videoReponse == null) {
      _videos.addError(response.error);
      return DialogStateType.ERROR;
    } else {
      _videos.sink.add(response.videoReponse.results);
    }
    return DialogStateType.SUCCESS;
  }

  dispose() {
    _videos.close();
  }
}
