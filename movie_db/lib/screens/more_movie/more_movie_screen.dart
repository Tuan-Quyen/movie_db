import 'package:flutter/material.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:movie_db/widgets/item_movie_vertical_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

import 'more_movie_bloc.dart';

class MoreMovieScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_MORE_VIDEOS_POPULAR;

  @override
  _MoreMovieScreenState createState() => _MoreMovieScreenState();
}

class _MoreMovieScreenState extends State<MoreMovieScreen> {
  final bloc = MoreMovieBloc();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scrollController = new ScrollController();
  List<MovieModel> _movies = [];
  int _page = 1, totalPage;

  @override
  void initState() {
    super.initState();
    checkError();
    _scrollController.addListener(loadMorePopular);
  }

  @override
  void dispose() {
    bloc.dispose();
    imageCache.clear();
    _scrollController.dispose();
    super.dispose();
  }

  //check api if error show dialog
  checkError() async{
    final movie = await bloc.getMoviePopular(_page);
    if(movie == DialogStateType.ERROR){
      MessageDialog().connection(this.context);
    }
  }

  Future<Null> onRefreshMovie() async {
    refreshKey.currentState?.show(atTop: true);
    _page = 1;
    totalPage = 0;
    _movies.clear();
    await checkError();
    return null;
  }

  void loadMorePopular() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      if (_page <= totalPage) {
        checkError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        context: context,
        titleAppBar: Constant.POPULAR_UPER,
        isCenterTitle: true,
        hasLeft: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: StreamBuilder<ResultMovie>(
            stream: bloc.movie.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data.results != null) {
                  totalPage = snapshot.data.totalPages;
                  _movies.addAll(snapshot.data.results);
                  snapshot.data.results = null;
                }
                return RefreshIndicator(
                  onRefresh: onRefreshMovie,
                  child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _movies.length + 1,
                      itemBuilder: (context, position) {
                        if (position < _movies.length) {
                          return ItemMovieVertical(_movies[position].id,
                              _movies[position], position, false, null);
                        }
                        if (position == _movies.length &&
                            position != 0 &&
                            _page < totalPage) {
                          return LoadWidget().buildLoadingMoreWidget(context);
                        }
                      }),
                );
              } else if (snapshot.hasError) {
                return LoadWidget().buildErrorWidget(snapshot.error, context);
              } else {
                return LoadWidget().buildLoadingWidget(context);
              }
            }),
      ),
    );
  }
}
