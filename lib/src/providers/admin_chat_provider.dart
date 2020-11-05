import 'package:flutter/material.dart';

class AdminChatProvider with ChangeNotifier {
  String _img;
  String _nombre;
  String _id;
  get id => _id;
  set id(String value) {
    this._id = value;
    notifyListeners();
  }

  get nombre => _nombre;
  set nombre(String value) {
    this._nombre = value;
    notifyListeners();
  }

  get foto => _img;
  set foto(String value) {
    this._img = value;
    notifyListeners();
  }
}
