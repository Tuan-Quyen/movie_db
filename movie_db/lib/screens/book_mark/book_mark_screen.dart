import 'package:flutter/material.dart';
import 'package:movie_db/interface/bookmark_listener.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:movie_db/widgets/item_movie_vertical_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

import 'book_mark_bloc.dart';

class BookMarkScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_BOOKMARK;
  static bool loadBookMark = false;
  static bool isLogin = false;
  static int movieID = 0;
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen>
    with AutomaticKeepAliveClientMixin<BookMarkScreen>
    implements BookMarkListener {
  final bloc = BookMarkBloc();
  var _scrollController = ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final List<MovieModel> _bookMark = [];
  int _page = 1, totalPage, selectedPosition;

  @override
  void initState() {
    super.initState();
    bloc.getUser().then((value) {
      BookMarkScreen.isLogin = value;
      if (value) {
        checkErrorMovieWatchList();
      }
    });
    _scrollController.addListener(_loadMore);
  }

  //check api if error show dialog
  checkErrorMovieWatchList() async {
    final movie = await bloc.getMovieWatchList(_page);
    if (movie == DialogStateType.ERROR) {
      MessageDialog().connection(this.context);
    }
  }

  @override
  void didUpdateWidget(BookMarkScreen oldWidget) {
    if (BookMarkScreen.loadBookMark) {
      _page = 1;
      totalPage = 0;
      _bookMark.clear();
      checkErrorMovieWatchList();
      print("Load");
      BookMarkScreen.loadBookMark = false;
    }

    if (BookMarkScreen.movieID != 0) {
      for (int i = 0; i<_bookMark.length; i++) {
        if (_bookMark[i].id == BookMarkScreen.movieID) {
          onClickBookMark(i);
          BookMarkScreen.movieID = 0;
          break;
        }
      }
    }

  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      if (_page <= totalPage) {
        checkErrorMovieWatchList();
      }
    }
  }

  Future<Null> onRefreshMovie() async {
    refreshKey.currentState?.show(atTop: true);
    _page = 1;
    totalPage = 0;
    _bookMark.clear();
    await checkErrorMovieWatchList();
    return null;
  }

  @override
  void dispose() {
    bloc.dispose();
    _scrollController.dispose();
    imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(
        context: context,
        titleAppBar: Constant.BOOK_MARK,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: BookMarkScreen.isLogin ? StreamBuilder<ResultMovie>(
            stream: bloc.movie.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.results != null) {
                  totalPage = snapshot.data.totalPages;
                  _bookMark.addAll(snapshot.data.results);
                  snapshot.data.results = null;
                } else if (snapshot.data.results == null &&
                    selectedPosition != null) {
                  _bookMark.length <= 20 ? totalPage = 0 : totalPage;
                  _bookMark.removeAt(selectedPosition);
                  selectedPosition = null;
                }
                return RefreshIndicator(
                  onRefresh: onRefreshMovie,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _bookMark.length + 1,
                    itemBuilder: (context, position) {
                      if (position < _bookMark.length) {
                        return ItemMovieVertical(_bookMark[position].id,
                            _bookMark[position], position, true, this);
                      }
                      if (position == _bookMark.length &&
                          position != 0 &&
                          _page < totalPage) {
                        return LoadWidget().buildLoadingMoreWidget(context);
                      }
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return LoadWidget().buildErrorWidget(snapshot.error, context);
              } else {
                return LoadWidget().buildLoadingWidget(context);
              }
            }) : Container(),
      ),
    );
  }

  @override
  Future onClickBookMark(int position) async {
    selectedPosition = position;
    final removeBookMark =
        await bloc.removeMovieWatchList(_bookMark[selectedPosition]);
    if (removeBookMark == DialogStateType.ERROR) {
      MessageDialog().connection(this.context);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
