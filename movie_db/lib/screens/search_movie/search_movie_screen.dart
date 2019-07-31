import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/screens/search_movie//search_movie_bloc.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:movie_db/widgets/item_movie_vertical_widget.dart';
import 'package:movie_db/widgets/load_widget.dart';

class SearchMovieScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_SEARCH_MOVIE;

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final bloc = SearchMovieBloc();
  var _searchController = TextEditingController();
  var _scrollController = ScrollController();
  List<MovieModel> _movies = [];
  int _page = 1, totalPage;
  CancelableOperation _operation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    bloc.dispose();
    imageCache.clear();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //check api if error show dialog
  checkError(String keyWord) async {
    final searchKeyWord = await bloc.searchKeyWordMovie(keyWord, _page);
    if (searchKeyWord == DialogStateType.ERROR) {
      MessageDialog().connection(this.context);
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _page++;
      if (_page <= totalPage) {
        checkError(_searchController.text.toString());
      }
    }
  }

  //reset page number, total page, movie list, *if it delaying search will be cancel future delay
  void onRefreshMovie() {
    _page = 1;
    totalPage = 0;
    _movies.clear();
    if (_operation != null) _operation.cancel();
  }

  //widget show a list by type of search (example: click movie => show a list of movie ,...)
  Widget _typeSearch(String type, bool checked, SearchMovieType searchType) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (searchType == SearchMovieType.MOVIE && !checked) {
          bloc.selectCastType();
        }
        if (searchType == SearchMovieType.CAST && !checked) {
          bloc.selectMovieType();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
        child: Text(
          type,
          style: TextStyle(
              color: checked ? ColorsUtils.orange : ColorsUtils.grey,
              fontSize: 16),
        ),
      ),
    );
  }

  //widget show a list of the movie
  Widget _movieListType(SearchMovieType type) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _typeSearch(Constant.MOVIE, true, type),
              _typeSearch(Constant.CASTS, false, type)
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: StreamBuilder<ResultMovie>(
                  stream: bloc.searchMovie.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.results != null) {
                        totalPage = snapshot.data.totalPages;
                        _movies.addAll(snapshot.data.results);
                        snapshot.data.results = null;
                      }
                      return ListView.builder(
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
                        },
                      );
                    } else if (snapshot.hasError) {
                      return LoadWidget()
                          .buildErrorWidget(snapshot.error, context);
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  //show a list of the caster(the function is maintaining)
  Widget _casterListType(SearchMovieType type) {
    return Row(
      children: <Widget>[
        _typeSearch(Constant.MOVIE, false, type),
        _typeSearch(Constant.CASTS, true, type)
      ],
    );
  }

  //main body widget of page
  Widget _bodyWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: ColorsUtils.white, fontSize: 20),
                decoration: InputDecoration.collapsed(
                    hintText: Constant.ENTER_KEY_WORD,
                    hintStyle:
                        TextStyle(color: ColorsUtils.white, fontSize: 20)),
                onChanged: (keyWord) {
                  onRefreshMovie();
                  if (keyWord.length >= 3) {
                    _operation = CancelableOperation.fromFuture(
                        Future.delayed(Duration(seconds: 2)));
                    _operation.value.whenComplete(() => checkError(keyWord));
                  }
                  //call bloc to update screen clear movie with empty keyword.
                  if (keyWord.length == 0)
                    bloc.searchKeyWordMovie(keyWord, null);
                },
                textInputAction: TextInputAction.search,
                //onPress key action
                onSubmitted: (keyWord) {
                  onRefreshMovie();
                  checkError(keyWord);
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                height: 2,
                color: ColorsUtils.orange),
            StreamBuilder(
                initialData: SearchMovieType.MOVIE,
                stream: bloc.typeMovie.stream,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case SearchMovieType.MOVIE:
                      return _movieListType(snapshot.data);
                    case SearchMovieType.CAST:
                      return _casterListType(snapshot.data);
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtils.black,
      appBar: AppBarWidget(hasLeft: true, context: context),
      body: _bodyWidget(),
    );
  }
}
