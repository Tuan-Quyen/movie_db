import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/model/movie_detail_model.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:movie_db/widgets/item_caster_horizontal_widget.dart';
import 'package:movie_db/widgets/item_tag_list_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';
import 'package:movie_db/widgets/rating_trailer_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:movie_db/screens/book_mark/book_mark_screen.dart';
import 'movie_detail_bloc.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_MOVIE_DETAIL;
  static bool isHaveBookMar = false;

  final int movieId;

  const MovieDetailScreen({Key key, @required this.movieId}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final bloc = MovieDetailBloc();

  @override
  void initState() {
    super.initState();
    getData();
  }

  //call api check connection
  Future getData() async {
    final detail = await bloc.getMovieDetail(widget.movieId);
    final caster = await bloc.getCasters(widget.movieId);
    if (detail == DialogStateType.ERROR || caster == DialogStateType.ERROR) {
      MessageDialog().connection(context);
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    imageCache.clear();
    super.dispose();
  }

  //List button right corrner in app bar
  List<Widget> _actionWidget() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 10, right: 20),
        child: StreamBuilder(
            stream: bloc.resultAddWatchList.stream,
            initialData: MovieDetailScreen.isHaveBookMar,
            builder: (context, snapshot) {
              return IconButton(
                  icon: !snapshot.data
                      ? Icon(
                          Icons.bookmark_border,
                          color: ColorsUtils.white,
                          size: 30,
                        )
                      : Icon(
                          Icons.bookmark,
                          color: ColorsUtils.orange,
                          size: 30,
                        ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    if (!snapshot.data) {
                      final dialogType =
                          await bloc.addWatchList(widget.movieId);
                      switch (dialogType) {
                        case DialogStateType.ERROR:
                          MessageDialog().connection(this.context);
                          break;
                        case DialogStateType.ADDEDBOOKMARK:
                          MessageDialog().information(
                              this.context, "", StringUtils.addedMovie, null);
                          break;
                        default:
                          break;
                      }
                    }
                    if (MovieDetailScreen.isHaveBookMar) {
                      BookMarkScreen.movieID = widget.movieId;
                      Navigator.pop(context);
                    }
                  });
            }),
      ),
    ];
  }

  //body widget in top show information image
  Widget _detailTopWidget(MovieDetailModel movie) {
    return Stack(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: <Widget>[
              FadeInImage(
                image: AdvancedNetworkImage(
                    ApiKeyParam.URL_IMAGE + movie.posterPath,
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                    timeoutDuration: Duration(seconds: 2),
                    retryLimit: 2,
                    fallbackAssetImage: "assets/images/ic_movie_failed.png"),
                fit: BoxFit.fill,
                placeholder: MemoryImage(kTransparentImage),
                width: 180,
                height: 250,
              ),
              Positioned.fill(
                  child: RatingTrailerWidget().ratingTrailerButton(
                      "${movie.voteAverage}",
                      Alignment.topRight,
                      Icons.star,
                      ColorsUtils.light_grey,
                      14,
                      12,
                      50,
                      30)),
            ]),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          movie.title.length <= 20
                              ? Text(movie.title,
                                  style: TextStyle(
                                      color: ColorsUtils.white, fontSize: 22))
                              : Text(movie.title,
                                  style: TextStyle(
                                      color: ColorsUtils.white, fontSize: 16)),
                          movie.runtime != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    bloc.formatDurationTime(movie.runtime),
                                    style: TextStyle(
                                        color: ColorsUtils.white, fontSize: 12),
                                  ))
                              : Container(),
                          Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Wrap(
                                children: <Widget>[
                                  TagListWidget().createTagText(movie.genres)
                                ],
                              )),
                          Container(
                              color: ColorsUtils.grey,
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    Text("${(movie.voteAverage * 10).toInt()}%",
                                        style: TextStyle(
                                            color: ColorsUtils.white,
                                            fontSize: 12)),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(Constant.USER_SCORE,
                                            style: TextStyle(
                                                color: ColorsUtils.white,
                                                fontSize: 12)))
                                  ]))
                        ]))),
          ],
        ),
        Positioned.fill(
            child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: RatingTrailerWidget().ratingTrailerButton(
                  Constant.TRAILER,
                  Alignment.bottomCenter,
                  Icons.play_arrow,
                  ColorsUtils.orange,
                  16,
                  30,
                  120,
                  45)),
          onTap: () {
            AppUtils().moveToScreen(
                context, Constant.SCREEN_MOVIE_VIDEO, widget.movieId, false);
          },
        ))
      ],
    );
  }

  //in midle of body widget show a text descripstion of the movie
  Widget _midleWidget(MovieDetailModel movie) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(Constant.OVERVIEW,
                style: TextStyle(color: ColorsUtils.white, fontSize: 20)),
            Container(
                margin: const EdgeInsets.only(top: 10),
                width: 120,
                height: 2,
                color: ColorsUtils.orange),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                movie.overview,
                style: TextStyle(color: ColorsUtils.white, fontSize: 18),
              ),
            )
          ]),
    );
  }

  //a main body widget of the page
  Widget _bodyWidget() {
    return SingleChildScrollView(
        child: StreamBuilder(
            stream: bloc.movieDetail.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _detailTopWidget(snapshot.data),
                      _midleWidget(snapshot.data),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(Constant.CASTS,
                                style: TextStyle(
                                    color: ColorsUtils.white, fontSize: 20)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 20),
                              width: 120,
                              height: 2,
                              color: ColorsUtils.orange),
                          //in bottom of body widget show a list of caster of the movie
                          Container(
                            height: 250,
                            child: StreamBuilder(
                                stream: bloc.caster.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, position) {
                                          return ItemCasterHorizontal(
                                              snapshot.data[position].id,
                                              snapshot
                                                  .data[position].casterName,
                                              snapshot
                                                  .data[position].casterImage,
                                              snapshot
                                                  .data[position].characterName,
                                              snapshot.data,
                                              position);
                                        });
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: LoadWidget().buildErrorWidget(
                                          snapshot.error, context),
                                    );
                                  } else {
                                    return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: LoadWidget()
                                            .buildLoadingWidget(context));
                                  }
                                }),
                          )
                        ],
                      )
                    ]);
              } else if (snapshot.hasError) {
                return LoadWidget().buildErrorWidget(snapshot.error, context);
              } else {
                return Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LoadWidget().buildLoadingWidget(context));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        context: context,
        hasLeft: true,
        actionWidget: _actionWidget(),
      ),
      body: _bodyWidget(),
    );
  }
}
