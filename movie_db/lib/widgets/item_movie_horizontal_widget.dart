import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/app_utils.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemMovieHorizontal extends StatelessWidget {
  final String title, linkImage;
  final int id, position;
  final List list;

  const ItemMovieHorizontal(
      this.id, this.title, this.linkImage, this.list, this.position);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: position == 0
          ? const EdgeInsets.only(left: 20, right: 10)
          : position == list.length - 1
              ? const EdgeInsets.only(left: 10, right: 20)
              : const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          AppUtils()
              .moveToScreen(context, Constant.SCREEN_MOVIE_DETAIL, id, false);
        },
        child: Container(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInImage(
                image: AdvancedNetworkImage(ApiKeyParam.URL_IMAGE + linkImage,
                    useDiskCache: true,
                    cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                    timeoutDuration: Duration(seconds: 2),
                    retryLimit: 2,
                    fallbackAssetImage: "assets/images/ic_movie_failed.png"),
                fit: BoxFit.fill,
                placeholder: MemoryImage(kTransparentImage),
                width: 150,
                height: 200,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: ColorsUtils.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
