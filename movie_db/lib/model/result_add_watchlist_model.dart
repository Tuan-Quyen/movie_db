class ResultAddWatchListModel{
  int statusCode;
  String statusMessage;

  ResultAddWatchListModel({this.statusCode, this.statusMessage});
  factory ResultAddWatchListModel.fromJson(Map<String, dynamic>json)=> new ResultAddWatchListModel(
      statusCode :json['status_code'],
      statusMessage :json['status_message']
  );
}