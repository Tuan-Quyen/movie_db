import 'package:flutter/material.dart';
import 'package:movie_db/utils/colors_utils.dart';

class AppBarWidget extends PreferredSize {
  final String titleAppBar; // title AppBar
  final bool isCenterTitle; // default title left appBar
  final bool hasLeft; // default no left icon back
  final double fontSizeTitle; // default fontSize = 25;
  final List<Widget> actionWidget; // default no Action icon right
  final BuildContext context;

  AppBarWidget(
      {this.hasLeft = false,
      this.context,
      this.titleAppBar,
      this.fontSizeTitle = 25,
      this.isCenterTitle = false,
      this.actionWidget})
      : super(
            preferredSize: Size.fromHeight(75.0),
            child: AppBar(
                backgroundColor: ColorsUtils.black,
                leading: hasLeft
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          color: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: ColorsUtils.white,
                            size: 20,
                          ),
                        ),
                      )
                    : null,
                title: titleAppBar != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          titleAppBar,
                          style: TextStyle(
                              color: ColorsUtils.white,
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : null,
                centerTitle: isCenterTitle,
                actions: actionWidget != null ? actionWidget : null));
}
