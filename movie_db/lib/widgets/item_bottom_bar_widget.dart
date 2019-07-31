import 'package:flutter/material.dart';
import 'package:movie_db/utils/colors_utils.dart';

class ItemBottomBar extends BottomNavigationBarItem {
  final IconData normalIcon;
  final IconData pressedIcon;

  ItemBottomBar({this.normalIcon, this.pressedIcon})
      : super(
            icon: Icon(normalIcon, color: ColorsUtils.grey),
            activeIcon: Icon(pressedIcon, color: ColorsUtils.orange),
            title: SizedBox.shrink());
}
