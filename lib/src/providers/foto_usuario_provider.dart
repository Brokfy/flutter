import 'package:flutter/material.dart';

class FotoUsuarioProvider with ChangeNotifier {
  Image _foto;
  get foto => _foto;
  set foto( Image value ) {
    this._foto = value;
    notifyListeners();
  }
}