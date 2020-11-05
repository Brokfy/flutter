import 'dart:io';

import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/db_service.dart';

import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/chat_detail_page_appbar.dart';
import '../widgets/chat/const.dart';
import '../models/chat_message.dart';
import '../models/send_menu_items.dart';
import '../providers/admin_chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:holding_gesture/holding_gesture.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {

  ChatDetailPage();
  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  AdminChatProvider admin;
  String peerId;
  String peerAvatar;
  String id;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String groupChatId;
  String _textField = '';

  String nombre;
  bool isNew;
  String bearer;

  @override
  void initState() { 
    super.initState();
    getUserInfo();

    listScrollController.addListener(_scrollListener);

    isLoading = false;
    imageUrl = '';
  }

  void getUserInfo() async {
    AuthApiResponse userInfo = await DBService.db.getAuthFirst();
    id = userInfo.username;
    peerAvatar = userInfo.nameAws;
    nombre = '${userInfo.nombre} ${userInfo.apellidoPaterno} ${userInfo.apellidoMaterno}';
    peerId =  '';
    isNew = true;
    bearer = userInfo.access_token;
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  _ChatDetailPageState();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    //SendMenuItems(text: "Location", icons: Icons.location_on, color: Colors.green),
    //SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.width * 0.70,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void _startRecording(LongPressStartDetails longPressedStart) {
    if (mounted) {
      print("Yo pense que tu sabias");
    }
  }

  void _stopRecording() {
    print("Es proyecto uno");
  }

  @override
  Widget build(BuildContext context) {
    if ( this.isNew == null ) {
      return Container();
    }

    admin = Provider.of<AdminChatProvider>(context);
    this.isNew ? this.peerId = admin.id : this.peerId = peerId;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    var _sendButton = GestureDetector(
        onTap: () {
          onSendMessage(_textField, 1);
        },
        child: Container(
          height: 30,
          width: 30,
          child: Icon(
            Icons.send,
            color: Color(0xFF0079DE),
            size: 30,
          ),
        ));

    var _voiceButton = GestureDetector(
        onLongPressStart: _startRecording,
        onLongPressUp: _stopRecording,
        child: Container(
          height: 30,
          width: 30,
          child: Icon(
            Icons.mic,
            color: Color(0xFF0079DE),
            size: 30,
          ),
        ));
groupChatId = "525514199304-525530551711";
    return Scaffold(
      appBar: PreferredSize(
          child: ChatDetailPageAppBar(
            nombre: this.nombre,
            img: this.peerAvatar,
            isNew: this.isNew,
            bearer: this.bearer,
          ),
          preferredSize: Size.fromHeight(100)),
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  if (snapshot.data.docs.length == 0) {
                    //return
                  } else {
                    listMessage.addAll(snapshot.data.docs);
                    return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Text("Tiempo aproximado de espera: 5 minutos",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black45)),
                            Text(
                                "Por favor espera unos minutos en lo que te asignamos un asesor.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black45)),
                            ListView.builder(
                              itemCount: snapshot.data.size,
                              shrinkWrap: true,
                              reverse: true,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatBubble(
                                  chatMessage: ChatMessage(
                                    message: snapshot.data.docs[index]
                                        .data()['content'],
                                    timestamp: snapshot.data.docs[index]
                                        .data()['timestamp'],
                                    type: (id ==
                                            snapshot.data.docs[index]
                                                .data()['idFrom'])
                                        ? MessageType.Sender
                                        : MessageType.Receiver,
                                  ),
                                );
                              },
                            )
                          ],
                        ));
                  }
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 0),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.add,
                        color: Color(0xFF0079DE),
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (term) {
                        onSendMessage(term, 1);
                      },
                      onChanged: (text) {
                        setState(() {
                          _textField = text;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Escribir mensaje",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    ),
                  ),
                  _textField != '' ? _sendButton : _voiceButton,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      addtoCloudFirestoListUser(content);
      addToCloudFirestore(content, type);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Escriba un texto',
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  /*Este vainoso agrega a la lista de chat o edita e secundayText, segun sea el caso */
  void addtoCloudFirestoListUser(String content) {
    this.isNew ? _agregarAlaLista(content) : _editarLista(content);
  }

  /* Este vainoso, agrega los mensajes de chat */
  void addToCloudFirestore(String content, int type) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': id,
          'idTo': peerId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type
        },
      );
    });
    /*Este otro vainoso agrega la lista de chats abiertos*/
  }

  void _agregarAlaLista(String content) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    var documentUserListReference =
        FirebaseFirestore.instance.collection(id).doc(admin.id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentUserListReference,
        {
          'id': (id == admin.id) ? id : admin.id,
          'image': admin.foto,
          'secondaryText': content,
          'text': admin.nombre,
          'time': formattedDate
        },
      );
    });
  }

  _editarLista(String secondaryText) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    FirebaseFirestore.instance.collection(id).doc(admin.id).update({
      "secondaryText": secondaryText,
      "time": formattedDate,
    });
  }
}
