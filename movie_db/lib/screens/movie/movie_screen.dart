import 'package:flutter/material.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:movie_db/widgets/item_movie_horizontal_widget.dart';
import 'package:movie_db/widgets/item_movie_vertical_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

import 'movie_bloc.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen();

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with AutomaticKeepAliveClientMixin<MovieScreen> {
  final bloc = MovieBloc();

  @override
  void initState() {
    bloc.fireBaseCloudMessagingListeners();
    super.initState();
    getData();
  }

  //call 2 api at start and check if have 1 failed api will show dialog!
  Future getData() async {
    final topRate = await bloc.getMovieTopRate();
    final popular = await bloc.getMoviePopular();
    if (topRate == DialogStateType.ERROR || popular == DialogStateType.ERROR) {
      MessageDialog().connection(context);
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    imageCache.clear();
    super.dispose();
  }

  //a main body widget of the page
  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Wrap(
        children: <Widget>[
          Container(
            height: 250,
            child: StreamBuilder<List<MovieModel>>(
                stream: bloc.movieTopRate.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {
                        return ItemMovieHorizontal(
                          snapshot.data[position].id,
                          snapshot.data[position].title,
                          snapshot.data[position].posterPath,
                          snapshot.data,
                          position,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: LoadWidget()
                          .buildErrorWidget(snapshot.error, context),
                    );
                  } else {
                    return Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: LoadWidget().buildLoadingWidget(context));
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  Constant.POPULAR,
                  style: TextStyle(fontSize: 20, color: ColorsUtils.white),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    AppUtils().moveToScreen(context,
                        Constant.SCREEN_MORE_VIDEOS_POPULAR, null, false);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      Constant.VIEW_ALL,
                      style: TextStyle(
                          color: ColorsUtils.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: StreamBuilder(
              stream: bloc.moviePopular.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {
                        return ItemMovieVertical(snapshot.data[position].id,
                            snapshot.data[position], position, false, null);
                      });
                } else if (snapshot.hasError) {
                  return Center(
                      child: LoadWidget()
                          .buildErrorWidget(snapshot.error, context));
                } else {
                  return Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: LoadWidget().buildLoadingWidget(context));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  //list button right corrner in app bar
  List<Widget> actionButton() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 10, top: 10),
        child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.search,
              color: ColorsUtils.orange,
              size: 30,
            ),
            onPressed: () {
              AppUtils().moveToScreen(
                  context, Constant.SCREEN_SEARCH_MOVIE, null, false);
            }),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: ColorsUtils.black,
        appBar: AppBarWidget(
          context: context,
          titleAppBar: Constant.MOVIES,
          actionWidget: actionButton(),
        ),
        body: _bodyWidget());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
