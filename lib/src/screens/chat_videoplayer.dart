import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class VideoPlayerPage extends StatefulWidget {
  String path;

  VideoPlayerPage({@required this.path});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  final f = new DateFormat('mm:ss');
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.path)
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Video',
        home: Scaffold(
          backgroundColor: Colors.black,
          body: _controller.value.initialized
              ? Stack(children: [
                  Center(
                      child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                            statusBarColor: Color(0xFFF9FAFA),
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            systemNavigationBarColor: Color(0xFFF9FAFA),
                            systemNavigationBarDividerColor: Colors.grey,
                            systemNavigationBarIconBrightness: Brightness.dark,
                          ));
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(0.0),
                        icon: Image.asset(
                          'assets/images/icons/Chat_Back@3x.png',
                          filterQuality: FilterQuality.high,
                        )),
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 65),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              height: 90,
                              minWidth: 90,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  side: BorderSide(
                                      color: Colors.white, width: 3)),
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              color: Colors.black38,
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                    ),
                  ]),
                  Positioned(
                    bottom: 100,
                    left: 30,
                    child: Text(
                      f.format(new DateTime.fromMillisecondsSinceEpoch(
                          _controller.value.position.inMilliseconds)),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    right: 30,
                    child: Text(
                      f.format(new DateTime.fromMillisecondsSinceEpoch(
                          _controller.value.duration.inMilliseconds)),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ])
              : Center(child: CircularProgressIndicator()),
        ));
  }
}
