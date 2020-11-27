import 'package:flutter/material.dart';

class AdminModel with ChangeNotifier {
  String _id;
  get id => _id;
  set id( String value ) {
    this._id = value;
    notifyListeners();
  }

  String _nombre;
  get nombre => _nombre;
  set nombre( String value ) {
    this._nombre = value;
    notifyListeners();
  }
  
  String _apellidoPaterno;
  get apellidoPaterno => _apellidoPaterno;
  set apellidoPaterno( String value ) {
    this._apellidoPaterno = value;
    notifyListeners();
  }

  String _apelldioMaterno;
  get apelldioMaterno => _apelldioMaterno;
  set apelldioMaterno( String value ) {
    this._apelldioMaterno = value;
    notifyListeners();
  }

  String _image;
  get image => _image;
  set image( String value ) {
    this._image = value;
    notifyListeners();
  }

  void limpiarAdmin() {
    this._id = "";
    this._nombre = '';
    this._apellidoPaterno = '';
    this._apelldioMaterno = '';
    this._image = '';
  }
}


class AdminModelResponse {
  AdminModelResponse({
    this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apelldioMaterno,
    this.image,
  });

  String id;
  String nombre;
  String apellidoPaterno;
  String apelldioMaterno;
  String image;

  factory AdminModelResponse.fromJson(Map<String, dynamic> json) => AdminModelResponse(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellidoPaterno"],
        apelldioMaterno: json["apelldioMaterno"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellidoPaterno": apellidoPaterno,
        "apelldioMaterno": apelldioMaterno,
        "image": image,
      };
}
