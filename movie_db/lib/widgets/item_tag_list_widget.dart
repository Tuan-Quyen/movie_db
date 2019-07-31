import 'package:flutter/material.dart';
import 'package:movie_db/model/genres_model.dart';
import 'package:movie_db/utils/colors_utils.dart';

class TagListWidget {
  Widget createTagText(List<GenreModel> tagList) {
    List<Widget> listWidget = new List<Widget>();
    for (int i = 0; i < tagList.length; i++) {
      if (i < tagList.length - 1) {
        listWidget.add(new Text(
          tagList[i].name + "/ ",
          style: TextStyle(
              color: ColorsUtils.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ));
      } else {
        listWidget.add(new Text(
          tagList[i].name,
          style: TextStyle(
              color: ColorsUtils.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ));
      }
    }
    return new Wrap(spacing: 4, children: listWidget);
  }
}
