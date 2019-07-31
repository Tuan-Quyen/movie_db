import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/utils/string_utils.dart';
import 'package:movie_db/widgets/app_bar_widget.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_ABOUT_US;

  @override
  State<StatefulWidget> createState() {
    return AboutUsScreenState();
  }
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBarWidget(
        titleAppBar: StringUtils.titleAboutUsScreen,
        context: context,
        fontSizeTitle: 20,
        isCenterTitle: true,
        hasLeft: true,
      ),
      url: "https://appscyclone.com/aboutus",
      hidden: true,
    );
  }
}
