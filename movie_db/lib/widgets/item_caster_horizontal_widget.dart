import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:movie_db/other/api_key_param.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemCasterHorizontal extends StatelessWidget {
  final String casterName, casterImage, characterName;
  final int position, id;
  final List list;

  const ItemCasterHorizontal(this.id, this.casterName, this.casterImage,
      this.characterName, this.list, this.position);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: position == 0
          ? const EdgeInsets.only(left: 20, right: 10)
          : position == list.length - 1
              ? const EdgeInsets.only(left: 10, right: 20)
              : const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInImage(
              image: AdvancedNetworkImage(ApiKeyParam.URL_IMAGE + casterImage,
                  useDiskCache: true,
                  cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                  retryLimit: 2,
                  timeoutDuration: Duration(seconds: 2),
                  fallbackAssetImage: "assets/images/ic_caster_failed.png"),
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              width: 120,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                casterName,
                style: TextStyle(
                    color: ColorsUtils.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                characterName,
                style: TextStyle(color: ColorsUtils.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
