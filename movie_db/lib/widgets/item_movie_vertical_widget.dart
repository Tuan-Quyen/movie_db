import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/interface/bookmark_listener.dart';
import 'package:movie_db/model/movie_model.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:movie_db/screens/movie_detail/movie_detail_screen.dart';
import 'item_tag_list_widget.dart';
import 'rating_trailer_widget.dart';

class ItemMovieVertical extends StatelessWidget {
  final MovieModel movie;
  final int position, id;
  final bool haveBookMark;
  final BookMarkListener listener;

  ItemMovieVertical(
      this.id, this.movie, this.position, this.haveBookMark, this.listener);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (haveBookMark) {
                MovieDetailScreen.isHaveBookMar = true;
              } else {
                MovieDetailScreen.isHaveBookMar = false;
              }
              AppUtils().moveToScreen(
                  context, Constant.SCREEN_MOVIE_DETAIL, id, false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FadeInImage(
                  image: AdvancedNetworkImage(
                      ApiKeyParam.URL_IMAGE + movie.posterPath,
                      useDiskCache: true,
                      cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                      retryLimit: 2,
                      timeoutDuration: Duration(seconds: 2),
                      fallbackAssetImage: "assets/images/ic_movie_failed.png"),
                  fit: BoxFit.fill,
                  placeholder: MemoryImage(kTransparentImage),
                  width: 120,
                  height: 180,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ColorsUtils.white, fontSize: 20)),
                        /*Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(movie.duration,
                                style: TextStyle(
                                    color: ColorsUtils.white, fontSize: 12))),*/
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Wrap(
                              children: <Widget>[
                                TagListWidget().createTagText(
                                    AppUtils().listGenres(movie.genreIds))
                              ],
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 110),
            child: RatingTrailerWidget().ratingTrailerButton(
                movie.voteAverage.toString(),
                Alignment.bottomCenter,
                Icons.star,
                ColorsUtils.orange,
                16,
                12,
                55,
                30),
          )),
          haveBookMark
              ? Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Icon(Icons.bookmark,
                        color: ColorsUtils.orange, size: 30),
                    onTap: () {
                      listener.onClickBookMark(position);
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
