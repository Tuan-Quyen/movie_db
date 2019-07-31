import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movie_db/model/map_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class MapBloc {
  final BehaviorSubject<List<MapMovieTheaterModel>> _movieTheaters =
      BehaviorSubject();

  BehaviorSubject<List<MapMovieTheaterModel>> get movieTheaters =>
      _movieTheaters;

  permissionLocation() async {
    //check status permission location
    PermissionStatus checkResultLocation = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (checkResultLocation.value != Constant.PERMISSION_GRANTED) {
      //Not Granted permission will request permission
      return await PermissionHandler()
          .requestPermissions([PermissionGroup.location]).then(
              (Map<PermissionGroup, PermissionStatus> status) async {
        if (status[PermissionGroup.location].value ==
            Constant.PERMISSION_GRANTED) {
          //Granted
          return true;
        } else {
          //Denied
          return false;
        }
      });
    } else {
      //Granted
      return true;
    }
  }

  List<LatLng> maps = [
    LatLng(10.845902, 106.644793),
    LatLng(10.8455374, 106.7791753),
    LatLng(10.8036483, 106.7174293),
    LatLng(10.8015073, 106.6172364),
    LatLng(10.8564609, 106.60786),
    LatLng(10.806081, 106.627393),
    LatLng(10.7703289, 106.7008651),
    LatLng(10.753756, 106.6741322),
    LatLng(10.7804476, 106.6825965),
    LatLng(10.7637612, 106.6875194),
  ];

  LatLng onPageViewChange(int page) {
    var center = LatLng(0.0, 0.0);
    return center = LatLng(movieTheaters.stream.value[page].geometry.lat,
        movieTheaters.stream.value[page].geometry.lng);
  }

  getMapTheaters() async {
    var baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7974985%2C106.6563041&radius=50000&keyword=CGV&key=AIzaSyAOZ5FtbdLgnuQWR8-7jHJDH8vHF7wnpB8';
    final response = await http.Client().get(baseUrl);

    if (response.statusCode == 200) {
      Map dataRes = jsonDecode(response.body);
      var res = dataRes['results'];
      List<MapMovieTheaterModel> maps = List<MapMovieTheaterModel>();
      for (var i = 0; i < res.length; i++) {
        var mapMovie = MapMovieTheaterModel.fromJson(res[i]);
        maps.add(mapMovie);
      }

      _movieTheaters.sink.add(maps);

      return _movieTheaters.value;
    } else {
      throw Exception('');
    }
  }

  dispose() {
    _movieTheaters.close();
  }
}
