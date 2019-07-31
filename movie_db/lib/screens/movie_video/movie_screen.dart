import 'package:flutter/material.dart';
import 'package:movie_db/other/constant.dart';
import 'package:movie_db/other/type_enum.dart';
import 'package:movie_db/utils/colors_utils.dart';
import 'package:movie_db/widgets/dialog_message.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:movie_db/widgets/load_widget.dart';
import 'movie_video_bloc.dart';

class MovieVideoScreen extends StatefulWidget {
  static const routeName = Constant.SCREEN_MOVIE_VIDEO;

  final int movieId;

  const MovieVideoScreen({Key key, @required this.movieId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieVideoScreenState();
}

class _MovieVideoScreenState extends State<MovieVideoScreen> {
  final bloc = MovieVideoBloc();

  YoutubePlayerController _controller = YoutubePlayerController();

  bool isOntapPlayerView = false;
  bool isAndroidDevice = false;

  @override
  void initState() {
    super.initState();
    checkError();
  }

  //check api if error show dialog
  checkError() async {
    final movie = await bloc.getMovieTopRate(widget.movieId);
    if (movie == DialogStateType.ERROR) {
      MessageDialog().connection(this.context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void listener() {
    if (_controller.value.playerState == PlayerState.ENDED) {}
    setState(() {});
  }

  StreamBuilder videoStream() {
    return StreamBuilder(
      stream: bloc.videos.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return containerPlayerForiOS(snapshot.data[0].key);
          }
          return Container();
        } else if (snapshot.hasError) {
          return LoadWidget().buildErrorWidget(snapshot.error, context);
        } else {
          return LoadWidget().buildLoadingWidget(context);
        }
      },
    );
  }

  YoutubePlayer containerPlayerForiOS(String videoId) {
    return new YoutubePlayer(
      liveUIColor: ColorsUtils.black,
      context: context,
      videoId: videoId,
      autoPlay: true,
      videoProgressIndicatorColor: ColorsUtils.orange,
      progressColors: ProgressColors(
        playedColor: ColorsUtils.orange,
        handleColor: ColorsUtils.orange,
      ),
      onPlayerInitialized: (controller) {
        _controller = controller;
        _controller.addListener(listener);
      },
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: isOntapPlayerView
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorsUtils.orange,
                      size: 30,
                    ),
                    onPressed: null)
                : new Container())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsUtils.black,
        appBar: AppBar(
          backgroundColor: ColorsUtils.black,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Trailer',
              style: TextStyle(
                  color: ColorsUtils.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          leading: BackButton(),
        ),
        body: Container(
          child: videoStream(),
        ),
      ),
    );
  }
}
