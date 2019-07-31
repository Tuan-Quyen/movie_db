import 'package:flutter/material.dart';
import 'package:movie_db/utils/colors_utils.dart';

class RatingTrailerWidget {
  Widget ratingTrailerButton(
      String text,
      Alignment alignment,
      IconData iconData,
      Color bgColor,
      double fontSize,
      double iconSize,
      double width,
      double height) {
    return Align(
        alignment: alignment,
        child: Container(
            width: width,
            height: height,
            color: bgColor,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconData,
                    color: ColorsUtils.black,
                    size: iconSize,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: ColorsUtils.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )));
  }
}
