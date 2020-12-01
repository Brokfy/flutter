import '../../models/chat_message.dart';
import '../../screens/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/audio_service.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
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
                    onTap: () {},
                    child: Image.network(widget.chatMessage.message))));
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

    return Column(
      children: [
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
