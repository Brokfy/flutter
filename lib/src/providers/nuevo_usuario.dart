import 'package:flutter/material.dart';

class NuevoUsuario with ChangeNotifier {
  String _email = 'correo@dominio.com';
  get email => _email;
  set email( String value ) {
    this._email = value;
    notifyListeners();
  }

  String _pais = '+52';
  get pais => _pais;
  set pais( String value ) {
    this._pais = value;
    notifyListeners();
  }

  String _telefono = '';
  get telefono => _telefono;
  set telefono( String value ) {
    this._telefono = value;
    notifyListeners();
  }

  String _password = '';
  get password => _password;
  set password( String value ) {
    this._password = value;
    notifyListeners();
  }

  String _nombre = '';
  get nombre => _nombre;
  set nombre( String value ) {
    this._nombre = value;
    notifyListeners();
  }

  String _apellidoPaterno = '';
  get apellidoPaterno => _apellidoPaterno;
  set apellidoPaterno( String value ) {
    this._apellidoPaterno = value;
    notifyListeners();
  }

  String _apellidoMaterno = '';
  get apellidoMaterno => _apellidoMaterno;
  set apellidoMaterno( String value ) {
    this._apellidoMaterno = value;
    notifyListeners();
  }

  String _fechaNacimiento = '';
  get fechaNacimiento => _fechaNacimiento;
  set fechaNacimiento( String value ) {
    this._fechaNacimiento = value;
    notifyListeners();
  }

  String _idVerificacionNumero = "";
  get idVerificacionNumero => _idVerificacionNumero;
  set idVerificacionNumero( String value ) {
    this._idVerificacionNumero = value;
    notifyListeners();
  }

  String _sexo = "";
  get sexo => _sexo;
  set sexo( String value ) {
    this._sexo = value;
    notifyListeners();
  }

  Image _foto;
  get foto => _foto;
  set foto( Image value ) {
    this._foto = value;
    notifyListeners();
  }

  void limpiarUsuario() {
    this._email = "";
    this._pais = '+52';
    this._telefono = '';
    this._password = '';
    this._nombre = '';
    this._apellidoPaterno = '';
    this._apellidoMaterno = '';
    this._fechaNacimiento = '';
    this._sexo = 'Masculino';
    this._idVerificacionNumero = '';
  }
}