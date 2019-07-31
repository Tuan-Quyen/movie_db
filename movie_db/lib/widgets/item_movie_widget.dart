import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class ItemMovieWidget extends StatelessWidget {
  final String urlImage;
  final String title;

  ItemMovieWidget({this.urlImage, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Stack(
        children: <Widget>[
          Image(
            image: AdvancedNetworkImage(
              'https://d2tml28x3t0b85.cloudfront.net/tracks/artworks/000/987/663/original/33a73a.jpeg?1550061132',
              useDiskCache: true,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
            ),
            fit: BoxFit.fill,
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Inception",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text("Action,aaa....",
                        style: TextStyle(fontSize: 12, color: Colors.white))
                  ],
                ),
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.red,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
