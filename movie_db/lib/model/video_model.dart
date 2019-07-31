
class VideoResponse {
  int id;
  List<Video> results;

  VideoResponse({
    this.id,
    this.results,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) => new VideoResponse(
    id: json["id"],
    results: new List<Video>.from(json["results"].map((x) => Video.fromJson(x))),
  );
}

class Video {

  String id;
  String iso_639_1;
  String iso_3166_1;
  String key;
  String name;
  String site;
  int size;
  String type;

  Video({
    this.id,
    this.iso_639_1,
    this.iso_3166_1,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) => new Video(
    id: json["id"],
    iso_639_1: json["iso_639_1"],
    iso_3166_1: json["iso_3166_1"],
    key: json["key"],
    name: json["name"],
    site: json["site"],
    size: json["size"],
    type: json["type"],
  );

}

class ResultGetListVideoResponse {
  final VideoResponse videoReponse;
  final String error;

  ResultGetListVideoResponse(this.videoReponse, this.error);

  ResultGetListVideoResponse.fromJson(Map<String, dynamic> json)
      : videoReponse = VideoResponse.fromJson(json),
        error = "";

  ResultGetListVideoResponse.withError(String errorValue)
      : videoReponse = null,
        error = errorValue;
}