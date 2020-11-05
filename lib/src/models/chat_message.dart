import '../screens/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage {
  String message;
  String timestamp;
  MessageType type;
  ChatMessage(
      {@required this.message, @required this.type, @required this.timestamp});
}
