import 'package:video_player/video_player.dart';
import '../../models/chat_message.dart';
import '../../screens/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/audio_service.dart';
import '../../screens/chat_videoplayer.dart';
import '../../screens/chat_imageviewer.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  String fechaMensaje;
  ChatBubble({@required this.chatMessage, @required this.fechaMensaje});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.chatMessage.messageType == 3)
      _controller = VideoPlayerController.network(widget.chatMessage.message)
        ..initialize().then((_) {
          setState(() {}); //when your thumbnail will show.
        });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.chatMessage.messageType == 3) _controller.dispose();
  }

  Widget message() {
    switch (widget.chatMessage.messageType) {
      case 1:
        //text
        return Text(widget.chatMessage.message,
            style: TextStyle(
                color: (widget.chatMessage.type == MessageType.Receiver
                    ? Colors.black
                    : Colors.white)));
      case 2:
        //image
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Card(
                elevation: 0,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                            statusBarColor: Color(0xFF000000),
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            systemNavigationBarColor: Color(0xFF000000),
                            systemNavigationBarDividerColor: Colors.grey,
                            systemNavigationBarIconBrightness: Brightness.dark,
                          ));
                          return ImageViewerPage(
                              path: widget.chatMessage.message);
                        }),
                      );
                    },
                    child: Image.network(widget.chatMessage.message))));
      case 3:
        //video
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: _controller.value.initialized
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                            statusBarColor: Color(0xFF000000),
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            systemNavigationBarColor: Color(0xFF000000),
                            systemNavigationBarDividerColor: Colors.grey,
                            systemNavigationBarIconBrightness: Brightness.dark,
                          ));
                          return VideoPlayerPage(
                              path: widget.chatMessage.message);
                        }),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: 200,
                      child: Stack(children: [
                        VideoPlayer(_controller),
                        Center(
                          child: FlatButton(
                            height: 80,
                            minWidth: 70,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                side:
                                    BorderSide(color: Colors.white, width: 1)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  SystemChrome.setSystemUIOverlayStyle(
                                      SystemUiOverlayStyle(
                                    statusBarColor: Color(0xFF000000),
                                    statusBarIconBrightness: Brightness.dark,
                                    statusBarBrightness: Brightness.light,
                                    systemNavigationBarColor: Color(0xFF000000),
                                    systemNavigationBarDividerColor:
                                        Colors.grey,
                                    systemNavigationBarIconBrightness:
                                        Brightness.dark,
                                  ));
                                  return VideoPlayerPage(
                                      path: widget.chatMessage.message);
                                }),
                              );
                            },
                            color: Colors.black38,
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]),
                    ))
                : CircularProgressIndicator());
      case 4:
        //audio
        return SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: PlayerWidget(url: widget.chatMessage.message));
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String _dueDate2 = new DateFormat('HH:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(widget.chatMessage.timestamp)));
    var dateParse = new DateTime.now();
    var todayDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    var yestParse = new DateTime.now().subtract(Duration(days: 1));
    var yestDate = "${yestParse.day}/${yestParse.month}/${yestParse.year}";
    return Column(
      children: [
        widget.fechaMensaje != null
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: new EdgeInsets.all(8.0),
                  decoration: new ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(15.0)),
                        side: BorderSide(color: Colors.black38, width: 1)),
                    // side: new BorderSide(color: Colors.white)
                  ),
                  child: Text(
                    widget.fechaMensaje == todayDate
                        ? "Hoy"
                        : widget.fechaMensaje == yestDate
                            ? "Ayer"
                            : widget.fechaMensaje,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                ),
              )
            : Container(),
        Container(
          padding: widget.chatMessage.messageType == 2 ||
                  widget.chatMessage.messageType == 3
              ? EdgeInsets.all(0)
              : EdgeInsets.all(2),
          margin: EdgeInsets.only(
              left: widget.chatMessage.type == MessageType.Receiver ? 10 : 50,
              right: widget.chatMessage.type == MessageType.Receiver ? 50 : 10,
              bottom: 5),
          child: Align(
            alignment: (widget.chatMessage.type == MessageType.Receiver
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.chatMessage.messageType == 2
                      ? BorderRadius.circular(20)
                      : BorderRadius.circular(10),
                  color: widget.chatMessage.messageType == 2
                      ? null
                      : (widget.chatMessage.type == MessageType.Receiver
                          ? Colors.grey.shade200
                          : Color(0xFF0079DE)),
                ),
                padding: widget.chatMessage.messageType != 1
                    ? EdgeInsets.all(0)
                    : EdgeInsets.all(10),
                child: message()),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: widget.chatMessage.type == MessageType.Receiver ? 20 : 0,
              right: widget.chatMessage.type == MessageType.Receiver ? 0 : 20,
              bottom: 5),
          child: Align(
              alignment: (widget.chatMessage.type == MessageType.Receiver
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: Text(_dueDate2.toString(),
                  style: TextStyle(
                      fontSize: 12,
                      color: widget.chatMessage.type == MessageType.Receiver
                          ? Colors.black45
                          : Color(0xFF0079DE)))),
        )
      ],
    );
  }
}
