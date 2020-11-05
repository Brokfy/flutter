import '../../models/chat_message.dart';
import '../../screens/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({@required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    String _dueDate2 = new DateFormat('HH:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(widget.chatMessage.timestamp)));

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: Align(
            alignment: (widget.chatMessage.type == MessageType.Receiver
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (widget.chatMessage.type == MessageType.Receiver
                    ? Colors.grey.shade200
                    : Color(0xFF0079DE)),
              ),
              padding:
                  EdgeInsets.only(top: 12, bottom: 12, right: 10.0, left: 25.0),
              child: Text(widget.chatMessage.message,
                  style: TextStyle(
                      color: (widget.chatMessage.type == MessageType.Receiver
                          ? Colors.black
                          : Colors.white))),
            ),
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
