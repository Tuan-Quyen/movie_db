import 'package:movie_db/model/result_add_watchlist_model.dart';

class ResultAddWatchListResponse {
  final ResultAddWatchListModel resultAddWatchListModel;
  final String error;

  ResultAddWatchListResponse(this.resultAddWatchListModel, this.error);

  ResultAddWatchListResponse.fromJson(Map<String, dynamic> json)
      : resultAddWatchListModel = ResultAddWatchListModel.fromJson(json),
        error = "";

  ResultAddWatchListResponse.withError(String errorValue)
      : resultAddWatchListModel = null,
        error = errorValue;
}
