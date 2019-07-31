class MapMovieTheaterModel {
  String name;
  String vicinity;
  PlusCode plusCode;
  Geometry geometry;

  MapMovieTheaterModel({
    this.name,
    this.vicinity,
    this.plusCode,
    this.geometry,
  });

  factory MapMovieTheaterModel.fromJson(Map<String, dynamic> json) => new MapMovieTheaterModel(
    name: json["name"],
    vicinity: json["vicinity"],
    plusCode: new PlusCode.fromJson(json["plus_code"]),
    geometry: new Geometry.fromJson(json["geometry"]),
  );
}

class Geometry {
  double lat;
  double lng;

  Geometry({
    this.lat,
    this.lng,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => new Geometry(
    lat: json['location']["lat"],
    lng: json['location']["lng"],
  );
}

class PlusCode {
  String compoundCode;

  PlusCode({
    this.compoundCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => new PlusCode(
    compoundCode: json["compound_code"],
  );
}
