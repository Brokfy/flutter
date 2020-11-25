import 'dart:io';
import 'dart:async';

import '../providers/admin_chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore.dart';

class ChatAsesorService {
  static final ChatAsesorService db = ChatAsesorService._();

  ChatAsesorService._();

  Future<void> uploadFile(
      String path,
      String fileType,
      String id,
      String peerId,
      AdminChatProvider admin,
      bool isNew,
      String groupChatId) async {
    String filename = path.split("/").last;
    Reference storageReference;
    var file = new File(path);
    int iFileType;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
      iFileType = 2;
    }
    if (fileType == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
      iFileType = 4;
    }
    if (fileType == 'video') {
      storageReference =
          FirebaseStorage.instance.ref().child("videos/$filename");
      iFileType = 3;
    }
    if (fileType == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
      iFileType = 5;
    }
    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
      iFileType = 6;
    }
    final TaskSnapshot taskSnapshot = await storageReference.putFile(file);

    taskSnapshot.ref.getDownloadURL().then((downloadUrl) => {
          // url archivo
          //Fluttertoast.showToast(msg: downloadUrl.toString())
          onSendMessage(
              downloadUrl, iFileType, id, peerId, admin, isNew, groupChatId)
        });
  }

  void onSendMessage(String content, int type, String id, String peerId,
      AdminChatProvider admin, bool isNew, String groupChatId) {
    // type: 0 = text, 1 = image, 2 = sticker
    int _peerId = peerId == '' || peerId == null ? 0 : int.parse(peerId);
    if (content.trim() != '') {
      addtoCloudFirestoListUser(content, id, admin, isNew);
      addToCloudFirestore(content, type, groupChatId, int.parse(id), _peerId);
    } else {
      Fluttertoast.showToast(
          msg: 'Escriba un texto',
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  /*Este vainoso agrega a la lista de chat o edita e secundayText, segun sea el caso */
  void addtoCloudFirestoListUser(
      String content, String id, AdminChatProvider admin, bool isNew) {
    isNew
        ? _agregarAlaLista(content, id, admin)
        : _editarLista(content, id, admin);
  }

  /* Este vainoso, agrega los mensajes de chat */
  void addToCloudFirestore(
      String content, int type, String groupChatId, int id, int peerId) {
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

  void _agregarAlaLista(String content, String id, AdminChatProvider admin) {
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

  _editarLista(String secondaryText, String id, AdminChatProvider admin) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    FirebaseFirestore.instance.collection(id).doc(admin.id).update({
      "secondaryText": secondaryText,
      "time": formattedDate,
    });
  }
}
