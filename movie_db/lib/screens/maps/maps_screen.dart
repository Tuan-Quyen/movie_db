import 'dart:io';

import 'package:movie_db/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'maps_bloc.dart';
import 'package:movie_db/model/map_model.dart';
import 'package:movie_db/widgets/load_widget.dart';

class MapMovieTheater extends StatefulWidget {
  const MapMovieTheater();

  @override
  _MapMovieTheaterState createState() => _MapMovieTheaterState();
}

class _MapMovieTheaterState extends State<MapMovieTheater>
    with AutomaticKeepAliveClientMixin<MapMovieTheater> {
  final bloc = MapBloc();

  PageController pageController = PageController();
  var currentPageValue = 0.0;

  GoogleMapController mapController;
  LatLng _center = LatLng(0.0, 0.0);
  Set<Marker> markers = Set();

  bool isFirstLoaded = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) bloc.permissionLocation();
    bloc.getMapTheaters();
  }

  @override
  void dispose() {
    bloc.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _onPageViewChange(int page) {
    setState(() {
      markers.addAll([
        Marker(
          markerId: MarkerId('$page'),
          position: bloc.onPageViewChange(page),
        ),
      ]);
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          bloc.onPageViewChange(page),
        ),
      );
    });


  }

  StreamBuilder mapItemStream() {
    return StreamBuilder(
      stream: bloc.movieTheaters.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!isFirstLoaded) {
            //To load first marker for first item. Call one time
            isFirstLoaded = true;
            _center = LatLng(
                snapshot.data[0].geometry.lat, snapshot.data[0].geometry.lng);
            markers.addAll([
              Marker(
                markerId: MarkerId('0'),
                position: bloc.onPageViewChange(0),
              ),
            ]);
          }
          return stackContainer(snapshot.data);
        } else if (snapshot.hasError) {
          return LoadWidget().buildErrorWidget(snapshot.error, context);
        }
      },
    );
  }

  Stack stackContainer(List<MapMovieTheaterModel> movieTheaters) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        GoogleMap(
          markers: markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          myLocationEnabled: true,
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          height: 140,
          child: mapItemList(movieTheaters),
        )
      ],
    );
  }

  PageView mapItemList(List<MapMovieTheaterModel> movieTheaters) {
    double width = MediaQuery.of(context).size.width;
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: pageController,
      itemCount: movieTheaters.length ?? 0,
      onPageChanged: _onPageViewChange,
      itemBuilder: (context, position) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          ),
          child: mapItem(width, position, movieTheaters),
        );
      },
    );
  }

  Container mapItem(
      double width, int index, List<MapMovieTheaterModel> movieTheaters) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 8, right: 10, bottom: 8),
            height: 110,
            width: 110,
            child: Image.network(
                'https://pbs.twimg.com/profile_images/1137906491640274944/HZ3HmK_Z_400x400.png'),
          ),
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 0, right: 5),
                    child: Container(
                      child: Text(
                        movieTheaters[index].name,
                        maxLines: 1,
                        style: TextStyle(
                            color: ColorsUtils.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Container(
                      height: 40,
                      child: Text(
                        movieTheaters[index].vicinity,
                        style: TextStyle(
                            color: ColorsUtils.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 11),
                        maxLines: 2,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 10),
                    child: Container(
                      child: Text("DIRECTION",
                          style: TextStyle(
                              color: ColorsUtils.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget googleMap() {
    return GoogleMap(
      markers: markers,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 13.0,
      ),
      myLocationEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      body: mapItemStream(),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
