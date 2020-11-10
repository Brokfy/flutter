import 'dart:typed_data';

import 'package:brokfy_app/src/models/admin_model.dart';
import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/models/codigo_postal_response.dart';
import 'package:brokfy_app/src/models/marcas_response.dart';
import 'package:brokfy_app/src/models/modelos_auto_response.dart';
import 'package:brokfy_app/src/models/chat_inicial_response.dart' as chatInicial;
import 'package:brokfy_app/src/models/chat_subir_poliza_response.dart' as chatSubirPoliza;
import 'package:brokfy_app/src/models/verificar_numero_response.dart';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import './db_service.dart';

class ApiService {
  static final url = 'https://apipruebas.brokfy.com/api';

  // Login
  static Future<AuthApiResponse> login(String phone, String password) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      'authorization': 'Basic ' +base64Encode(utf8.encode('frontendapp:12345')),
    };

    Map<String, dynamic> formData =  {
      "username": "$phone",
      "password": "$password",
      "grant_type": "password"
    };

    http.Response response = await http.post(
      "$url/security/oauth/token", 
      headers: headers, 
      body: formData
    );
    final int statusCode = response.statusCode;
    
    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("Error en el request");
    }

    if ( statusCode == 400 ) {
      var resp = json.decode(response.body);
      print(resp["error_description"]);
      throw new Exception(resp["error_description"] ?? "Error en el request");
    }

    AuthApiResponse apiResponse = AuthApiResponse.fromJson(json.decode(response.body));
    if( apiResponse.access_token == null ) {
      throw new Exception("No se recibe la respuesta esperada");
    }

    return AuthApiResponse.fromJson(json.decode(response.body));
  }

  static Future<AdminModel> getAdminChat(String bearer) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      'authorization': 'Bearer ' + bearer,
    };

    http.Response response =
        await http.get("$url/brokfy/get_admin", headers: headers);
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("No se pudo procesar la solicitud");
    }
    String source = Utf8Decoder().convert(response.bodyBytes);
    AdminModel adminModel = AdminModel.fromJson(json.decode(source));
    return adminModel;
  }

  // Crear Usuario
  static Future<VerificarNumeroResponse> verificarNumeroCelular(String numero, String email) async {
    http.Response response = await http.get(
      "$url/verificacion/vNumCelular/$numero/$email"
    );
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("No se pudo procesar la solicitud");
    }

    VerificarNumeroResponse apiResponse = VerificarNumeroResponse.fromJson(json.decode(response.body));
    // if( apiResponse.status == null || apiResponse.status.toString() == "" ) {
    //   throw new Exception("No se pudo verificar el número");
    // }

    return apiResponse;
  }

  static Future<VerificarNumeroResponse> validarCodigoVerificacionIngresado(String idVerificacion, String pin) async {
    http.Response response = await http.get("$url/verificacion/cNumCelular/$idVerificacion/$pin");
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("Error en el request");
    }

    VerificarNumeroResponse apiResponse = VerificarNumeroResponse.fromJson(json.decode(response.body));
    if( apiResponse.status == null || apiResponse.status.toString() == "" ) {
      throw new Exception("No se pudo verificar el número");
    }
    
    return apiResponse;
  }

  static Future<VerificarNumeroResponse> reenviarCodigoVerificacion(String numero, String idVerificacion) async {
    http.Response response = await http.get("$url/verificacion/reenviar/$numero/$idVerificacion");
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("Error en el request");
    }

    VerificarNumeroResponse apiResponse = VerificarNumeroResponse.fromJson(json.decode(response.body));
    if( apiResponse.status == null || apiResponse.status.toString() == "" ) {
      throw new Exception("No se pudo verificar el número");
    }

    return apiResponse;
  }

  static Future<bool> registrarNuevoUsuario(NuevoUsuario nuevoUsuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // md5.convert(utf8.encode(nuevoUsuario.password)).toString(),

    Map<String, dynamic> data = {
      "username": '${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}',
      "password": new DBCrypt().hashpw(nuevoUsuario.password, new DBCrypt().gensalt()),
      "enabled": "true",
      "intentos": 0,
      "idConekta": null,
      "token": null,
      "nameAws": null,
      "tokenF": null,
      "roles": [
        {
          "id":1,"nombre": "ROLE_USER"
        }
      ],
      "perfil": {
        "nombre": nuevoUsuario.nombre,
        "apellidoPaterno": nuevoUsuario.apellidoPaterno,
        "apellidoMaterno": nuevoUsuario.apellidoMaterno,
        "fechaNacimiento": nuevoUsuario.fechaNacimiento,
        "sexo": nuevoUsuario.sexo,
        "email": nuevoUsuario.email,
        "username": '${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}'
      }
    };

    http.Response response = await http.post(
      "$url/usuario/usuario",
      headers: headers,
      body: json.encode(data)
    );
    final int statusCode = response.statusCode;

    if ( statusCode != 201 ) {
      return false;
    }
    
    return true;
  }

  // cambiar imagen perfil
  static Future<bool> actualizarImagenPerfil(String username, File image) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
    var length = await image.length(); 

    var uri = Uri.parse("$url/brokfy/editaImagenPerfil");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFileSign = new http.MultipartFile('file', stream, length,
        filename: basename(image.path));

    request.files.add(multipartFileSign);

    request.headers.addAll(headers);

    request.fields['username'] = username;

    var response = await request.send();

    final int statusCode = response.statusCode;

    if ( statusCode != 200 && statusCode != 201 ) {
      return false;
    }
    
    return true;
  }

  static Future<VerificarNumeroResponse> recuperarPassword(String numero) async {
    http.Response response = await http.get(
      "$url/verificacion/vUser/$numero"
    );
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("No se pudo procesar la solicitud");
    }

    VerificarNumeroResponse apiResponse = VerificarNumeroResponse.fromJson(json.decode(response.body));
    if( apiResponse.status == null || apiResponse.status.toString() == "" ) {
      throw new Exception("No se pudo verificar el número");
    }

    return apiResponse;
  }

  static Future<bool> cambiarPassword(String numero, String password) async {
    String passwordEncriptado = await compute(_getTextoEncriptado, password);
    
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    Map<String, dynamic> formData =  {
      "username": "$numero",
      "password": passwordEncriptado,
    };


    http.Response response = await http.post(
      "$url/brokfy/actualizaPassword",
      headers: headers,
      body: json.encode(formData)
    );
    final int statusCode = response.statusCode;

    return statusCode == 200;
  }

  void logout() async {
    // await _oauth.logout();
  }

  static Future<String> _getTextoEncriptado(String password) async {
    return new DBCrypt().hashpw(password, new DBCrypt().gensalt());
  }

  static Future<AuthApiResponse> _getAuth() async {
    try {
      AuthApiResponse auth = await DBService.db.getAuthFirst();
      if( auth.access_token != null && auth.access_token != "" ) {
        return auth;
      }  
    } catch (e) {}
    return null;
  }

  static Future<String> _refreshToken(String token) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      'authorization': 'Basic ' +base64Encode(utf8.encode('frontendapp:12345')),
    };

    Map<String, dynamic> formData =  {
      "grant_type": "refresh_token",
      "refresh_token": token
    };

    http.Response response = await http.post(
      "$url/security/oauth/token", 
      headers: headers, 
      body: formData
    );
    final int statusCode = response.statusCode;
    
    if (statusCode < 200 || statusCode > 400 || json == null ) {
      throw new Exception("Error en el request");
    }

    if ( statusCode == 400 ) {
      var resp = json.decode(response.body);
      print(resp["error_description"]);
      throw new Exception(resp["error_description"] ?? "Error en el request");
    }

    AuthApiResponse apiResponse = AuthApiResponse.fromJson(json.decode(response.body));
    if( apiResponse.access_token == null ) {
      throw new Exception("No se recibe la respuesta esperada");
    }

    await DBService.db.updateAuth(apiResponse);

    return apiResponse.access_token;    
  }

  static Future<chatInicial.ChatInicialResponse> iniciarChat({String step = "1"}) async {
    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat/$step", 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat/1", 
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        chatInicial.ChatInicialResponse _chat = chatInicial.ChatInicialResponse.fromJson(json.decode(bodyUtf8));
        return _chat;
      }  
    } catch (e) {}
    
    return null;
  }

  static Future<List<chatSubirPoliza.ChatSubirPolizaResponse>> subirPoliza() async {
    final List<chatSubirPoliza.ChatSubirPolizaResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat/subirPoliza", 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat/subirPoliza", 
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        final decodedData = json.decode(bodyUtf8);
        if( decodedData == null ) return [];

        decodedData.forEach((item){
          final tempResponse = chatSubirPoliza.ChatSubirPolizaResponse.fromJson(item);
          listadoRetorno.add( tempResponse );
        });
        
        return listadoRetorno;
      }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }

  static Future<Map<String, dynamic>> subirPolizaSubmit(Map<String, dynamic> data, Uri uri, String filePath) async {
    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      var request = new http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath("file", filePath));
      request.fields['nombre'] = data["tipoPoliza"].tipo.toString();
      request.fields['username'] = (await DBService.db.getAuthFirst()).username;
      request.fields['numPoliza'] = data["nroPoliza"];
      request.fields['idAseguradora'] =  data["aseguradora"].idAseguradora.toString();
      request.fields['firmada'] =  "0";
      request.fields['tipoSeguro'] = data["tipoPoliza"].id.toString();

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        request.headers.addAll(headers);

        var response = await request.send();
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          if( response.headers["www-authenticate"].contains("invalid_token") ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            var requestRetry = new http.MultipartRequest("POST", uri);
            requestRetry.files.add(await http.MultipartFile.fromPath("file", filePath));
            requestRetry.fields['nombre'] = data["tipoPoliza"].tipo.toString();
            requestRetry.fields['username'] = (await DBService.db.getAuthFirst()).username;
            requestRetry.fields['numPoliza'] = data["nroPoliza"];
            requestRetry.fields['idAseguradora'] =  data["aseguradora"].idAseguradora.toString();
            requestRetry.fields['firmada'] =  "0";
            requestRetry.fields['tipoSeguro'] = data["tipoPoliza"].id.toString();
            requestRetry.headers.addAll(headers);
            response = await requestRetry.send();
            statusCode = response.statusCode;
          }
        }

        if( statusCode == 200 ) {
          final respStr = await response.stream.bytesToString();
          var parsedJson = json.decode(respStr);
          return parsedJson;
        }
      }  
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<bool> obtenerPolizaSubmit(Map<String, dynamic> data, Uri uri, ByteData buffer) async {
    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      Uint8List bufferUint8List = buffer.buffer.asUint8List(buffer.offsetInBytes, buffer.lengthInBytes);
      List<int> bytes = bufferUint8List.cast<int>();
      Stream<List<int>> stream = http.ByteStream.fromBytes(bytes);
      String username = (await DBService.db.getAuthFirst()).username;

      var request = new http.MultipartRequest("POST", uri);
      // request.files.add(await http.MultipartFile("file", stream, bytes.length));
      request.files.add(await http.MultipartFile.fromBytes("file", bytes, filename: 'firma_$username.png'));
      request.fields['nombre'] = data["tipoPoliza"].tipo.toString();
      request.fields['username'] = (await DBService.db.getAuthFirst()).username;
      request.fields['aseguradora'] =  data["aseguradora"].nombre.toString();
      request.fields['numPoliza'] = data["nroPoliza"];
      request.fields['firmada'] =  "1";
      request.fields['tipoSeguro'] = data["tipoPoliza"].id.toString();
      request.fields['idAseguradora'] =  data["aseguradora"].idAseguradora.toString();
      request.fields['urlPoliza'] =  data["urlPoliza"].toString();

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };
        request.headers.addAll(headers);

        var response = await request.send();
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          if( response.headers["www-authenticate"].contains("invalid_token") ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            var requestRetry = new http.MultipartRequest("POST", uri);
            // request.files.add(await http.MultipartFile("file", stream, bytes.length));
            request.files.add(await http.MultipartFile.fromBytes("file", bytes, filename: 'firma_$username.png'));
            request.fields['nombre'] = data["tipoPoliza"].tipo.toString();
            request.fields['username'] = (await DBService.db.getAuthFirst()).username;
            request.fields['aseguradora'] =  data["aseguradora"].nombre.toString();
            request.fields['numPoliza'] = data["nroPoliza"];
            request.fields['firmada'] =  "1";
            request.fields['tipoSeguro'] = data["tipoPoliza"].id.toString();
            request.fields['idAseguradora'] =  data["aseguradora"].idAseguradora.toString();
            request.fields['urlPoliza'] =  data["urlPoliza"].toString();
            requestRetry.headers.addAll(headers);
            response = await requestRetry.send();
            statusCode = response.statusCode;
          }
        }

        if( statusCode == 200 || statusCode == 201 ) {
          final respStr = await response.stream.bytesToString();
          var parsedJson = json.decode(respStr);
          print(parsedJson);
          return true;
        }
      }  
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<chatInicial.ChatInicialResponse> contratarPoliza() async {    
    return await iniciarChat(step: "2");
  }

  static Future<List<chatSubirPoliza.ChatSubirPolizaResponse>> getFormularioContratarPoliza(String tipoPoliza) async {
    final List<chatSubirPoliza.ChatSubirPolizaResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat$tipoPoliza", 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat$tipoPoliza",
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        final decodedData = json.decode(bodyUtf8);
        if( decodedData == null ) return [];

        decodedData.forEach((item){
          final tempResponse = chatSubirPoliza.ChatSubirPolizaResponse.fromJson(item);
          listadoRetorno.add( tempResponse );
        });
        
        return listadoRetorno;
      }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }

  static Future<List<CodigoPostalResponse>> validarCodigoPostal(String _url, String codigoPostal) async {
    final List<CodigoPostalResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat$_url".replaceFirst("{codPostal}", codigoPostal), 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat$_url".replaceFirst("{codPostal}", codigoPostal), 
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        final decodedData = json.decode(bodyUtf8);
        if( decodedData == null ) return [];

        decodedData.forEach((item){
          final tempResponse = CodigoPostalResponse.fromJson(item);
          listadoRetorno.add( tempResponse );
        });
        
        return listadoRetorno;
      }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }

  static Future<List<MarcasResponse>> getMarcasXAnio(String _url, String anio) async {
    final List<MarcasResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat$_url".replaceFirst("{anio}", anio), 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat$_url".replaceFirst("{anio}", anio), 
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        final decodedData = json.decode(bodyUtf8);
        if( decodedData == null ) return [];

        decodedData.forEach((item){
          final tempResponse = MarcasResponse.fromJson(item);
          listadoRetorno.add( tempResponse );
        });
        
        return listadoRetorno;
      }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }

  static Future<List<ModelosAutoResponse>> getModelosAuto(String _url, String anio, String marca) async {
    final List<ModelosAutoResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      if( token != null ) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        };

        http.Response response = await http.get(
          "$url/chat$_url".replaceFirst("{anio}", anio).replaceFirst("{marca}", marca), 
          headers: headers, 
        );
        int statusCode = response.statusCode;

        if ( statusCode == 401 ) {
          var resp = json.decode(response.body);
          if( resp["error"] == "invalid_token" ) {
            token = await _refreshToken(refreshToken);

            Map<String, String> headers = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            };

            http.Response response = await http.get(
              "$url/chat$_url".replaceFirst("{anio}", anio).replaceFirst("{marca}", marca), 
              headers: headers, 
            );
            statusCode = response.statusCode;
          }
        }
        
        if (statusCode < 200 || statusCode > 400 || json == null ) {
          throw new Exception("Error en el request");
        }

        if ( statusCode == 400 ) {
          var resp = json.decode(response.body);
          print(resp["error_description"]);
          throw new Exception(resp["error_description"] ?? "Error en el request");
        }
        var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
        final decodedData = json.decode(bodyUtf8);
        if( decodedData == null ) return [];

        decodedData.forEach((item){
          final tempResponse = ModelosAutoResponse.fromJson(item);
          listadoRetorno.add( tempResponse );
        });
        
        return listadoRetorno;
      }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }

  static Future<List<ModelosAutoResponse>> submitCotizarPolizaAuto(String _url, Map<String, String> data) async {
    final List<ModelosAutoResponse> listadoRetorno = new List();

    try {
      AuthApiResponse auth = await _getAuth();
      String token = auth.access_token;
      String refreshToken = auth.refresh_token;

      // if( token != null ) {
      //   Map<String, String> headers = {
      //     "Content-Type": "application/json",
      //     "Authorization": "Bearer $token"
      //   };

      //   http.Response response = await http.get(
      //     "$url/chat$_url".replaceFirst("{anio}", anio).replaceFirst("{marca}", marca), 
      //     headers: headers, 
      //   );
      //   int statusCode = response.statusCode;

      //   if ( statusCode == 401 ) {
      //     var resp = json.decode(response.body);
      //     if( resp["error"] == "invalid_token" ) {
      //       token = await _refreshToken(refreshToken);

      //       Map<String, String> headers = {
      //         "Content-Type": "application/json",
      //         "Authorization": "Bearer $token"
      //       };

      //       http.Response response = await http.get(
      //         "$url/chat$_url".replaceFirst("{anio}", anio).replaceFirst("{marca}", marca), 
      //         headers: headers, 
      //       );
      //       statusCode = response.statusCode;
      //     }
      //   }
        
      //   if (statusCode < 200 || statusCode > 400 || json == null ) {
      //     throw new Exception("Error en el request");
      //   }

      //   if ( statusCode == 400 ) {
      //     var resp = json.decode(response.body);
      //     print(resp["error_description"]);
      //     throw new Exception(resp["error_description"] ?? "Error en el request");
      //   }
      //   var bodyUtf8 = Utf8Decoder().convert(response.bodyBytes);
      //   final decodedData = json.decode(bodyUtf8);
      //   if( decodedData == null ) return [];

      //   decodedData.forEach((item){
      //     final tempResponse = ModelosAutoResponse.fromJson(item);
      //     listadoRetorno.add( tempResponse );
      //   });
        
      //   return listadoRetorno;
      // }  
    } catch (e) {
      print(e.toString());
    }
    
    return null;
  }
}
