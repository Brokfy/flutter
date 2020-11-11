import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/api_service.dart';
import '../models/chat_inicial_response.dart' as chatInicial;
import '../models/chat_subir_poliza_response.dart' as chatSubirPoliza;
import '../models/codigo_postal_response.dart';
import '../models/marcas_response.dart';
import '../models/modelos_auto_response.dart';
import '../widgets/loading.dart';
import '../widgets/select_option_from_list.dart';
import '../widgets/jumping_dots_progress_indicator.dart';
import 'package:path/path.dart' as pathLib;
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatPolizaScreen extends StatefulWidget {
  @override
  _ChatPolizaScreenState createState() => _ChatPolizaScreenState();
}

class _ChatPolizaScreenState extends State<ChatPolizaScreen> {
  List<chatInicial.Opcione> _opciones;
  List<chatInicial.Opcione> _opcionesCompra;
  bool loading;
  List<Map<String, String>> _chat = [];
  bool showDataEntry;
  String dataEntryType;
  List<chatSubirPoliza.ChatSubirPolizaResponse> _continuacionChat;
  int indexPregunta = 0;
  ScrollController _scrollController;
  bool writting;
  TextEditingController _nroPolizaController;
  TextEditingController _codigoPostalController;
  FixedExtentScrollController _fixedExtentScrollController;
  List<MarcasResponse> marcas = [];
  List<ModelosAutoResponse> modelos = [];

  Map<String, dynamic> agregarPolizaData = {
    "aseguradora": null,
    "tipoPoliza": null,
    "nroPoliza": null,
  };
  File file;
  String filePath;
  Uri fileUri;
  final _sign = GlobalKey<SignatureState>();
  

  Map<String, dynamic> contratarPolizaData = {
    "tipoPoliza": null,
    "codigoPostal": null,
    "year": null,
    "marca": null,
    "modelo": null,
    "formaPago": null,
  };

  @override
  void initState() {
    super.initState();
    loading = true;
    showDataEntry = false;
    writting = false;
    _scrollController = ScrollController();
    _nroPolizaController = TextEditingController();
    _codigoPostalController = TextEditingController();
    _fixedExtentScrollController =  FixedExtentScrollController();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nroPolizaController.dispose();
    _scrollController.dispose();
    _codigoPostalController.dispose();
    _fixedExtentScrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initChat();
  }

  void initChat() async {
    if( _chat.length == 0 ) {
      chatInicial.ChatInicialResponse _saludo = await ApiService.iniciarChat();
      _opciones = _saludo.opciones;
      loading = false;
      writting = false;
      setState(() {});

      int index = 0;
      for (var pregunta in _saludo.preguntas) {
        String mensaje = pregunta.pregunta;
        if (index == 0) {
          AuthApiResponse auth = await DBService.db.getAuthFirst();
          mensaje = mensaje.replaceAll(r'%s', auth.nombre);
        }
        writting = true;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 20 * mensaje.length));

        writting = false;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 200));
        _chat.add({
          "mensaje": mensaje,
          "autor": "Brokfy"
        });
        setState(() {});
        index++;
      }

      setState(() {
        dataEntryType = "accionPrincipal";
        showDataEntry = true;
      });
    }
  }

  seleccionarAccionPrincipal(chatInicial.Opcione opcion) async {
    if( opcion.endpoint == "/subirPoliza" ) { // Quiero subir una poliza
      List<chatSubirPoliza.ChatSubirPolizaResponse> apiResponse = await ApiService.subirPoliza();
      _continuacionChat = apiResponse;
      for (var pregunta in apiResponse[indexPregunta].preguntas) {
        writting = true;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

        writting = false;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 200));        

        _chat.add({
          "mensaje": pregunta.pregunta,
          "autor": "Brokfy"
        });  
      }
      showDataEntry = true;
      dataEntryType = "aseguradora";
      setState(() {});
    } else { // Quiero contratar una poliza nueva
      chatInicial.ChatInicialResponse _contratar = await ApiService.contratarPoliza();
      _opcionesCompra = _contratar.opciones;
      loading = false;
      writting = false;
      setState(() {});

      int index = 0;
      for (var pregunta in _contratar.preguntas) {
        String mensaje = pregunta.pregunta;
        if (index == 0) {
          AuthApiResponse auth = await DBService.db.getAuthFirst();
          mensaje = mensaje.replaceAll(r'%s', auth.nombre);
        }
        writting = true;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 20 * mensaje.length));

        writting = false;
        setState(() {});
        await Future.delayed(Duration(milliseconds: 200));
        _chat.add({
          "mensaje": mensaje,
          "autor": "Brokfy"
        });
        setState(() {});
        index++;
      }

      setState(() {
        dataEntryType = "tipoPolizaContratar";
        showDataEntry = true;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#F9FAFA"),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: HexColor("#F9FAFA"),
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    if ( _scrollController.positions.length > 0 ) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    if( loading ) {
      return SafeArea(
        child: Scaffold(
          body: Loading(),
        )
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#FCFBFF"),
        appBar: _appBarChatBuild(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: _chatBuild(),
            ),

            _dataEntryBuild(),
          ],
        )
      ),
    );
  }

  Widget _dataEntryBuild() {
    if( showDataEntry != true ) return Container();
    return Container(
      // color: Colors.white,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFDBE6F0),
            width: 1
          )
        )
      ),
      child: Column(
        children: dataEntryType == "accionPrincipal" ? _seleccionAccionPrincipalBuild() : 
          dataEntryType == "aseguradora" ? _seleccionAseguradoraBuild() : 
          dataEntryType == "tipoPoliza" ? _seleccionTipoPolizaBuild() : 
          dataEntryType == "tipoPolizaContratar" ? _seleccionTipoPolizaContratarBuild() : 
          dataEntryType == "nroAseguradora" ? _seleccionNroPolizaBuild() : 
          dataEntryType == "subirPoliza" ? _seleccionPolizaPDFBuild() : 
          dataEntryType == "aceptoCartaNombramiento" ? _seleccionAceptacionCartaNombramiento() : 
          dataEntryType == "finChat" ? _seleccionFinChat() : 
          dataEntryType == "codigoPostal" ? _seleccionContratarCodigoPostalBuild() : 
          dataEntryType == "anoModelo" ? _seleccionContratarAnoModeloBuild() : 
          dataEntryType == "marca" ? _seleccionContratarMarcaBuild() : 
          dataEntryType == "modelo" ? _seleccionContratarModeloBuild() : 
          dataEntryType == "pago" ? _seleccionContratarPagoBuild() : 
          [],
      ),
    );
  }

  List<Widget> _seleccionContratarPagoBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"),
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: GestureDetector(
                onTap: () async {
                    dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatSubirPoliza.Opcione>(
                        builder: (BuildContext context) {
                          return SelectOptionFromList(
                            _continuacionChat[indexPregunta].opciones,
                            [],
                            title: "Forma de pago",
                            field: "opcion",
                            textStyle: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(15),
                              color: Color(0xFF4F5351)
                            )
                          );
                        },
                      fullscreenDialog: true
                    ));

                    if( seleccion != null ) {
                      setState(() {
                        contratarPolizaData["formaPago"] = seleccion;
                      });
                    }
                },
                child: Text(
                  contratarPolizaData["formaPago"] != null ? contratarPolizaData["formaPago"].opcion : 'Selecciona la forma de pago',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: contratarPolizaData["formaPago"] != null ? HexColor("#4F5351") : HexColor("#B3B3B3")
                  ),
                ),
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( contratarPolizaData["formaPago"] == null ) return;
                        _chat.add({
                          "mensaje": contratarPolizaData["formaPago"].opcion,
                          "autor": "Usuario"
                        });
                        showDataEntry = false;
                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 200));

                          _chat.add({
                            "mensaje": pregunta.pregunta.replaceAll("%s", contratarPolizaData["formaPago"].opcion),
                            "autor": "Brokfy"
                          });  
                        }
                        showDataEntry = true;
                        dataEntryType = "tipoPoliza";

                        await Future.delayed(Duration(milliseconds: 200));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionContratarModeloBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"),
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: GestureDetector(
                onTap: () async {
                    dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<ModelosAutoResponse>(
                        builder: (BuildContext context) {
                          return SelectOptionFromList(
                            modelos,
                            [],
                            title: "Modelo",
                            field: "nombre",
                            textStyle: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(15),
                              color: Color(0xFF4F5351)
                            )
                          );
                        },
                      fullscreenDialog: true
                    ));

                    if( seleccion != null ) {
                      setState(() {
                        contratarPolizaData["modelo"] = seleccion;
                      });
                    }
                },
                child: Text(
                  contratarPolizaData["modelo"] != null ? contratarPolizaData["modelo"].nombre : 'Selecciona el modelo',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: contratarPolizaData["modelo"] != null ? HexColor("#4F5351") : HexColor("#B3B3B3")
                  ),
                ),
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( contratarPolizaData["modelo"] == null ) return;
                        _chat.add({
                          "mensaje": contratarPolizaData["modelo"].nombre,
                          "autor": "Usuario"
                        });
                        showDataEntry = false;
                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 200));

                          _chat.add({
                            "mensaje": pregunta.pregunta.replaceAll("%s", contratarPolizaData["modelo"].nombre),
                            "autor": "Brokfy"
                          });  
                        }
                        showDataEntry = true;
                        dataEntryType = "pago";

                        await Future.delayed(Duration(milliseconds: 200));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionContratarMarcaBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"),
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: GestureDetector(
                onTap: () async {
                    dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<MarcasResponse>(
                        builder: (BuildContext context) {
                          return SelectOptionFromList(
                            marcas,
                            [],
                            title: "Marcas",
                            field: "nombre",
                            textStyle: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(15),
                              color: Color(0xFF4F5351)
                            )
                          );
                        },
                      fullscreenDialog: true
                    ));

                    if( seleccion != null ) {
                      setState(() {
                        contratarPolizaData["marca"] = seleccion;
                      });
                    }
                },
                child: Text(
                  contratarPolizaData["marca"] != null ? contratarPolizaData["marca"].nombre : 'Selecciona la marca',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: contratarPolizaData["marca"] != null ? HexColor("#4F5351") : HexColor("#B3B3B3")
                  ),
                ),
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( contratarPolizaData["marca"] == null ) return;
                        _chat.add({
                          "mensaje": contratarPolizaData["marca"].nombre,
                          "autor": "Usuario"
                        });
                        showDataEntry = false;
                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 200));

                          _chat.add({
                            "mensaje": pregunta.pregunta.replaceAll("%s", contratarPolizaData["marca"].nombre),
                            "autor": "Brokfy"
                          });  
                        }

                        showDataEntry = true;
                        dataEntryType = "modelo";

                        modelos = await ApiService.getModelosAuto(_continuacionChat[indexPregunta].opciones[0].endpoint, contratarPolizaData["year"], contratarPolizaData["marca"].nombre);

                        await Future.delayed(Duration(milliseconds: 200));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionContratarAnoModeloBuild() {
    int index = -1;
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          // bottom: ScreenUtil().setHeight(10),
        ),
        child: Text(
          "Selecciona el año",
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(14),
            color: Color(0xFF535353),
          ),
        )
      ),
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
          margin: EdgeInsets.all(0),
          // padding: EdgeInsets.all(0),
          width: ScreenUtil().setWidth(307),
          height: ScreenUtil().setHeight(200),
          child: ListWheelScrollView(
            controller: _fixedExtentScrollController,
            physics: BouncingScrollPhysics(),
            onSelectedItemChanged: (value) {
              contratarPolizaData["year"] = value;
              setState(() {});
            },
            children: _continuacionChat[indexPregunta].opciones[0].data.map((year) {
              index++;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Text(
                        year.anio.toString(),
                        style: TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: _fixedExtentScrollController.hasClients ? 
                            (index == _fixedExtentScrollController.selectedItem ? FontWeight.bold : FontWeight.w400) : 
                            (index == _fixedExtentScrollController.initialItem ? FontWeight.bold : FontWeight.w400),
                          color: _fixedExtentScrollController.hasClients ? 
                            (index == _fixedExtentScrollController.selectedItem ? Color(0xFF0079DE) : Color(0xFF999999)) : 
                            (index == _fixedExtentScrollController.initialItem ? Color(0xFF0079DE) : Color(0xFF999999))
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            itemExtent: ScreenUtil().setHeight(60),
          )
        ),
      ),

      Padding(
        padding: EdgeInsets.only(
          // top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Container(
          height: ScreenUtil().setHeight(60),
          margin: EdgeInsets.symmetric(
            // vertical: ScreenUtil().setHeight(28),
            horizontal: ScreenUtil().setWidth(50),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor("#0079DE").withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: ScreenUtil().setHeight(9),
                offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
              ),
            ],
          ),
          child: RaisedButton(
            onPressed: () async {
              String anioSeleccionado = _continuacionChat[indexPregunta].opciones[0].data[contratarPolizaData["year"]].anio.toString();
              contratarPolizaData["year"] = anioSeleccionado;
              _chat.add({
                "mensaje": anioSeleccionado,
                "autor": "Usuario"
              });
              showDataEntry = false;
              indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
              setState(() {});

              for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                writting = true;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 80));
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));
                writting = false;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 80));

                _chat.add({
                  "mensaje": pregunta.pregunta,
                  "autor": "Brokfy"
                });  
              }

              marcas = await ApiService.getMarcasXAnio(_continuacionChat[indexPregunta].opciones[0].endpoint, contratarPolizaData["year"]);

              showDataEntry = true;
              dataEntryType = "marca";
              setState(() {});
              await Future.delayed(Duration(milliseconds: 80));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            splashColor: Color.fromRGBO(255, 255, 255, 0.2),
            disabledColor: HexColor("#C4C4C4"),
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                color: HexColor("#C4C4C4"),
                gradient: LinearGradient(
                  colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continuar",
                      style: TextStyle(
                        color: HexColor("#FFFFFF"),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(15),
                        fontFamily: 'SF Pro', 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ),
      
    ];
  }

  List<Widget> _seleccionContratarCodigoPostalBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              margin: EdgeInsets.all(0),
              // padding: EdgeInsets.all(0),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"), 
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextFormField(
                controller: _codigoPostalController,
                cursorColor: Colors.black,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 5,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400
                ),
                decoration: new InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: "Código postal"
                ).copyWith(
                  hintStyle: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: Color(0xFFB3B3B3)
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'SF Pro',
                    color: Color(0xFFB3B3B3)
                  ),
                  counterText: "",
                ),
              )
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( _codigoPostalController.text == null || _codigoPostalController.text.length < 5 ) return;
                        contratarPolizaData["codigoPostal"] = _codigoPostalController.text;
                        _codigoPostalController.text = "";
                        
                        _chat.add({
                          "mensaje": contratarPolizaData["codigoPostal"],
                          "autor": "Usuario"
                        });
                        showDataEntry = false;

                        String endpoint = _continuacionChat[indexPregunta].opciones[0].endpoint;
                        List<CodigoPostalResponse> response =  await ApiService.validarCodigoPostal(endpoint, contratarPolizaData["codigoPostal"]);
                        if ( response == null || response.length == 0 ) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 80));
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                          _chat.add({
                            "mensaje": "El código postal indicado no es válido",
                            "autor": "Brokfy"
                          }); 

                          for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                            writting = true;
                            setState(() {});
                            await Future.delayed(Duration(milliseconds: 80));
                            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                            await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));
                            writting = false;
                            setState(() {});
                            await Future.delayed(Duration(milliseconds: 80));

                            _chat.add({
                              "mensaje": pregunta.pregunta,
                              "autor": "Brokfy"
                            });  

                            showDataEntry = true;
                            setState(() {});
                            return;
                          }
                        }

                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 80));
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));
                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 80));

                          _chat.add({
                            "mensaje": pregunta.pregunta,
                            "autor": "Brokfy"
                          });  
                        }
                        showDataEntry = true;
                        dataEntryType = "anoModelo";
                        setState(() {});
                        await Future.delayed(Duration(milliseconds: 80));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionTipoPolizaContratarBuild() {
    return [
      Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(28),
          horizontal: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () async {
            dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatInicial.Opcione>(
                builder: (BuildContext context) {
                  return SelectOptionFromList(
                    _opcionesCompra,
                    [],
                    title: "Tipos de seguros",
                    field: "opcion",
                    textStyle: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(15),
                      color: Color(0xFF4F5351)
                    )
                  );
                },
              fullscreenDialog: true
            ));

            if( seleccion != null ) {
              contratarPolizaData["tipoPoliza"] = seleccion;
              _chat.add({
                "mensaje": contratarPolizaData["tipoPoliza"].opcion,
                "autor": "Usuario"
              });
              showDataEntry = false;
              setState(() {});

              if( seleccion.endpoint == null )  return;

              List<chatSubirPoliza.ChatSubirPolizaResponse> apiResponse = await ApiService.getFormularioContratarPoliza(seleccion.endpoint);
              _continuacionChat = apiResponse;
              
              indexPregunta = 0;
              for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                writting = true;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                writting = false;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 200));

                _chat.add({
                  "mensaje": pregunta.pregunta,
                  "autor": "Brokfy"
                });  
              }
              showDataEntry = true;
              dataEntryType = "codigoPostal";
              setState(() {});
              
              await Future.delayed(Duration(milliseconds: 50));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Seleccionar tipo de póliza",
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      fontFamily: 'SF Pro', 
                    ),
                  ),

                  Container(
                    width: ScreenUtil().setWidth(38),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Icon(Icons.chevron_right, color: Colors.white)
                        ),
                        Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3))
                      ]
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      )
      
    ];
  }

  List<Widget> _seleccionFinChat() {
    return [
      SizedBox(height: ScreenUtil().setHeight(28),),

      ..._continuacionChat[indexPregunta].opciones.where((element) => element.opcion != null).map((e) {
        return Container(
          height: ScreenUtil().setHeight(60),
          margin: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(28),
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor("#0079DE").withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: ScreenUtil().setHeight(9),
                offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
              ),
            ],
          ),
          child: RaisedButton(
            onPressed: () async {
              if( e.opcion.toLowerCase().contains("salir") ) {
                Navigator.of(context).popAndPushNamed("home");
              } else {
                _chat.add({
                  "mensaje": e.opcion,
                  "autor": "Usuario"
                });
                setState(() {});
                await Future.delayed(Duration(milliseconds: 20 *  e.opcion.length));

                await Future.delayed(Duration(milliseconds: 75));
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                setState(() {});

                seleccionarAccionPrincipal(chatInicial.Opcione.fromJson({
                  "mensaje": e.opcion,
                  "endpoint": "/subirPoliza"
                }));
                indexPregunta = 0;
                agregarPolizaData = {
                  "aseguradora": null,
                  "tipoPoliza": null,
                  "nroPoliza": null
                };
                setState(() {});
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            splashColor: Color.fromRGBO(255, 255, 255, 0.2),
            disabledColor: HexColor("#C4C4C4"),
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                color: HexColor("#C4C4C4"),
                gradient: LinearGradient(
                  colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.opcion,
                      style: TextStyle(
                        color: HexColor("#FFFFFF"),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(15),
                        fontFamily: 'SF Pro', 
                      ),
                    ),                    
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList()
    ];
  }

  List<Widget> _seleccionAceptacionCartaNombramiento() {
    var items = _continuacionChat[indexPregunta].opciones.where((element) => element.opcion != null).toList();
    return  [
      Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(28),
          horizontal: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () async {
            dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<dynamic>(
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: Color(0xFFFCFBFF),
                      appBar: _appBarFirmaDigitalBuild(),
                      body: Column(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Signature(
                              color: Colors.black,
                              strokeWidth: ScreenUtil().setWidth(4), 
                              backgroundPainter: null, 
                              onSign: null, 
                              key: _sign, 
                            ),
                          ),

                          Flexible(
                            flex: 2,
                            child: Container(
                              // color: Colors.blue,
                              child: Column(
                                children: [
                                  CustomPaint(
                                    size: Size(ScreenUtil.screenWidth * 0.8, 10),
                                    painter: HandSignatureLine(ScreenUtil.screenWidth * 0.8, ScreenUtil().setWidth(1.3)),
                                  ),

                                  SizedBox(height: ScreenUtil().setHeight(20),),
                                  Text(
                                    'Dibuje su firma sobre esta línea',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: ScreenUtil().setSp(13),
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF000000).withOpacity(0.5)
                                    ),
                                  ),
                                  
                                  Container(
                                    height: ScreenUtil().setHeight(60),
                                    margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(23),
                                      horizontal: ScreenUtil().setWidth(112),
                                    ),
                                    child: RaisedButton(
                                      onPressed: () async {
                                        final sign = _sign.currentState;
                                        sign.clear();
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                                      disabledColor: HexColor("#C4C4C4"),
                                      textColor: Colors.white,
                                      disabledTextColor: Colors.white,
                                      padding: EdgeInsets.all(0.0),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          color: HexColor("#5A666F"),
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Borrar",
                                                style: TextStyle(
                                                  color: HexColor("#FFFFFF"),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil().setSp(15),
                                                  fontFamily: 'SF Pro', 
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xFFDBE6F0)
                                  )
                                )
                              ),
                              child: Container(
                                height: ScreenUtil().setHeight(60),
                                margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(28),
                                  horizontal: ScreenUtil().setWidth(50),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: HexColor("#0079DE").withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: ScreenUtil().setHeight(9),
                                      offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: RaisedButton(
                                  onPressed: () async {
                                    final sign = _sign.currentState;
                                    //retrieve image data, do whatever you want with it (send to server, save locally...)
                                    final image = await sign.getData();
                                    var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                    sign.clear();
                                    final encoded = base64.encode(data.buffer.asUint8List());
                                    Navigator.of(context).pop(data);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                                  disabledColor: HexColor("#C4C4C4"),
                                  textColor: Colors.white,
                                  disabledTextColor: Colors.white,
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: HexColor("#C4C4C4"),
                                      gradient: LinearGradient(
                                        colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0)
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Continuar",
                                            style: TextStyle(
                                              color: HexColor("#FFFFFF"),
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(15),
                                              fontFamily: 'SF Pro', 
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  );
                },
              fullscreenDialog: true
            ));

            if( seleccion != null ) {
              String url = _continuacionChat[indexPregunta].opciones[0].url;
              var uri = Uri.parse(url);

              _chat.add({
                "mensaje": items[0].opcion,
                "autor": "Usuario",
              });

              writting = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 20 * items[0].opcion.length));

              await Future.delayed(Duration(milliseconds: 75));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
              
              if ( await ApiService.obtenerPolizaSubmit(agregarPolizaData, uri, seleccion) ) {
                indexPregunta = _continuacionChat.indexWhere((element) => element.id == items[0].action);
                setState(() {});

                for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                  writting = true;
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                  writting = false;
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 50));

                  _chat.add({
                    "mensaje": pregunta.pregunta,
                    "autor": "Brokfy",
                    "anexos": pregunta.anexos
                  });

                  await Future.delayed(Duration(milliseconds: 75));
                  setState(() {});
                  
                  await Future.delayed(Duration(milliseconds: 75));
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  setState(() {});
                }
                showDataEntry = true;
                dataEntryType = "finChat";
                setState(() {});
                
                await Future.delayed(Duration(milliseconds: 50));
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                setState(() {});
              }
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    items[0].opcion,
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      fontFamily: 'SF Pro', 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(28),
          left: ScreenUtil().setWidth(50),
          right: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () async {
            _chat.add({
              "mensaje": items[1].opcion,
              "autor": "Usuario",
            });
            showDataEntry = false;
            writting = true;
            setState(() {});
            await Future.delayed(Duration(milliseconds: 20 * items[1].opcion.length));

            await Future.delayed(Duration(milliseconds: 75));
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            setState(() {});

            indexPregunta = _continuacionChat.indexWhere((element) => element.id == items[1].action);
            setState(() {});

            for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
              writting = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

              writting = false;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 50));

              _chat.add({
                "mensaje": pregunta.pregunta,
                "autor": "Brokfy",
                "anexos": pregunta.anexos
              });

              await Future.delayed(Duration(milliseconds: 75));
              setState(() {});
              
              await Future.delayed(Duration(milliseconds: 75));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            }
            showDataEntry = true;
            dataEntryType = "finChat";
            setState(() {});
            
            await Future.delayed(Duration(milliseconds: 50));
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            setState(() {});
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    items[1].opcion,
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      fontFamily: 'SF Pro', 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> _seleccionPolizaPDFBuild() {
    return [
      Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(28),
          horizontal: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () async {
            file = await FilePicker.getFile(
              type: FileType.CUSTOM,
              fileExtension: 'pdf'
            );

            if( file == null ) return;

            filePath = file.path;
            fileUri = file.uri;

            String filename = pathLib.basename(file.path);

            try {
              showDataEntry = false;
              _chat.add({
                "mensaje": filename,
                "autor": "Usuario"
              });  
              setState(() {});

              String url = _continuacionChat[indexPregunta].opciones[0].url;
              var uri = Uri.parse(url);
              Map<String, dynamic> response = await ApiService.subirPolizaSubmit(agregarPolizaData, uri, filePath);
              if ( response == null ) {
                showDataEntry = true;
                return;
              } 
              
              agregarPolizaData["urlPoliza"] = response["urlPoliza"];

            } catch(ex) {
              print(ex);
            }
            
            indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
            setState(() {});

            for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
              writting = true;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

              writting = false;
              setState(() {});
              await Future.delayed(Duration(milliseconds: 50));

              _chat.add({
                "mensaje": pregunta.pregunta,
                "autor": "Brokfy",
                "anexos": pregunta.anexos
              });

              await Future.delayed(Duration(milliseconds: 75));
              setState(() {});
              
              await Future.delayed(Duration(milliseconds: 75));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            }
            showDataEntry = true;
            dataEntryType = "aceptoCartaNombramiento";
            setState(() {});
            
            await Future.delayed(Duration(milliseconds: 50));
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            setState(() {});
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Subir póliza",
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      fontFamily: 'SF Pro', 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> _seleccionNroPolizaBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              margin: EdgeInsets.all(0),
              // padding: EdgeInsets.all(0),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"), 
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextFormField(
                controller: _nroPolizaController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w400
                ),
                decoration: new InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: "Número de póliza"
                ).copyWith(
                  hintStyle: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: Color(0xFFB3B3B3)
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'SF Pro',
                    color: Color(0xFFB3B3B3)
                  ),
                ),
              )
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( _nroPolizaController.text == null || _nroPolizaController.text.length == 0 ) return;
                        agregarPolizaData["nroPoliza"] = _nroPolizaController.text;
                        _nroPolizaController.text = "";
                        
                        _chat.add({
                          "mensaje": agregarPolizaData["nroPoliza"],
                          "autor": "Usuario"
                        });
                        showDataEntry = false;
                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 80));
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));
                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 80));

                          _chat.add({
                            "mensaje": pregunta.pregunta,
                            "autor": "Brokfy"
                          });  
                        }
                        showDataEntry = true;
                        dataEntryType = "subirPoliza";
                        setState(() {});
                        await Future.delayed(Duration(milliseconds: 80));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionTipoPolizaBuild() {
    return [
      Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(28),
          horizontal: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () async {
            dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatSubirPoliza.Datum>(
                builder: (BuildContext context) {
                  return SelectOptionFromList(
                    _continuacionChat[indexPregunta].opciones[0].data,
                    [],
                    title: "Tipos de seguros",
                    field: "tipo",
                    textStyle: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(15),
                      color: Color(0xFF4F5351)
                    )
                  );
                },
              fullscreenDialog: true
            ));

            if( seleccion != null ) {
              agregarPolizaData["tipoPoliza"] = seleccion;
              _chat.add({
                "mensaje": agregarPolizaData["tipoPoliza"].tipo,
                "autor": "Usuario"
              });
              showDataEntry = false;
              indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
              setState(() {});

              for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                writting = true;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                writting = false;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 200));

                _chat.add({
                  "mensaje": pregunta.pregunta,
                  "autor": "Brokfy"
                });  
              }
              showDataEntry = true;
              dataEntryType = "nroAseguradora";
              setState(() {});
              
              await Future.delayed(Duration(milliseconds: 50));
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              setState(() {});
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Seleccionar tipo de póliza",
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      fontFamily: 'SF Pro', 
                    ),
                  ),

                  Container(
                    width: ScreenUtil().setWidth(38),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 0,
                          child: Icon(Icons.chevron_right, color: Colors.white)
                        ),
                        Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3))
                      ]
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      )
      
    ];
  }
  
  List<Widget> _seleccionAseguradoraBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all( ScreenUtil().setHeight(14) ),
              width: ScreenUtil().setWidth(307),
              decoration: BoxDecoration(
                border: Border.all(
                  color: HexColor("#EEEEEE"),
                  width: ScreenUtil().setWidth(1.5),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: GestureDetector(
                onTap: () async {
                    dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatSubirPoliza.Datum>(
                        builder: (BuildContext context) {
                          return SelectOptionFromList(
                            _continuacionChat[indexPregunta].opciones[0].data,
                            [],
                            title: "Aseguradoras",
                            field: "nombre",
                            textStyle: TextStyle(
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(15),
                              color: Color(0xFF4F5351)
                            )
                          );
                        },
                      fullscreenDialog: true
                    ));

                    if( seleccion != null ) {
                      setState(() {
                        agregarPolizaData["aseguradora"] = seleccion;
                      });
                    }
                },
                child: Text(
                  agregarPolizaData["aseguradora"] != null ? agregarPolizaData["aseguradora"].nombre : 'Selecciona tu aseguradora',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(16),
                    color: agregarPolizaData["aseguradora"] != null ? HexColor("#4F5351") : HexColor("#B3B3B3")
                  ),
                ),
              ),
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  text: 'Enviar',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w500,
                    color: HexColor("#0079DE"),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async { 
                        if( agregarPolizaData["aseguradora"] == null ) return;
                        _chat.add({
                          "mensaje": agregarPolizaData["aseguradora"].nombre,
                          "autor": "Usuario"
                        });
                        showDataEntry = false;
                        indexPregunta = _continuacionChat.indexWhere((element) => element.id == _continuacionChat[indexPregunta].opciones[0].action);
                        setState(() {});

                        for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                          writting = true;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                          writting = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 200));

                          _chat.add({
                            "mensaje": pregunta.pregunta.replaceAll("%s", agregarPolizaData["aseguradora"].nombre),
                            "autor": "Brokfy"
                          });  
                        }
                        showDataEntry = true;
                        dataEntryType = "tipoPoliza";

                        await Future.delayed(Duration(milliseconds: 200));
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        setState(() {});
                      }
                ),
              )
            )
          ],
        ),
      )
      
    ];
  }

  List<Widget> _seleccionAccionPrincipalBuild() {
    return [
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(28),
          bottom: ScreenUtil().setHeight(28),
        ),
        child: Text(
          'Selecciona una opción:',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: ScreenUtil().setSp(14),
            color: Color(0xFF535353)
          ),
        ),
      ),  
      ..._opciones.map((e) => _botonOpcionBuild(e))
    ];
  }

  Widget _botonOpcionBuild(chatInicial.Opcione opcion) {
    return Container(
      height: ScreenUtil().setHeight(60),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(50),
        right: ScreenUtil().setWidth(50),
        bottom: ScreenUtil().setHeight(30),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: HexColor("#0079DE").withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: ScreenUtil().setHeight(9),
            offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
          ),
        ],
      ),
      child: RaisedButton(
        onPressed: () { 
          _chat.add({
            "mensaje": opcion.opcion,
            "autor": "Usuario"
          });
          showDataEntry = false;
          setState(() {});
          seleccionarAccionPrincipal(opcion);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        splashColor: Color.fromRGBO(255, 255, 255, 0.2),
        disabledColor: HexColor("#C4C4C4"),
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            color: HexColor("#C4C4C4"),
            gradient: LinearGradient(
              colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Container(
            // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              opcion.opcion,
              style: TextStyle(
                color: HexColor("#FFFFFF"),
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(15),
                fontFamily: 'SF Pro', 
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatBuild() {
    return Row(
      children: [
        Flexible(flex: 1, child: Container()),
        Flexible(
          flex: 8,
          child: ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(), 
            itemCount: _chat.length,
            itemBuilder: (BuildContext context, int index) {
              if ( index == _chat.length - 1 ) {
                Future.delayed(Duration(milliseconds: 90), () {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });
                return Column(
                  children: [
                    _mensajeChatBuild(
                      mensaje: _chat[index]["mensaje"],
                      tipo: _chat[index]["autor"]
                    ),

                    _chat[index]["anexos"] != null ?
                      _formatoCartaNombramientoBuild(_chat[index]["anexos"]) :
                      Container(),

                    writting == true ?
                      _mensajeChatBuild(
                        mensaje: "...",
                        tipo: "Brokfy"
                      ) : Container(),
                  ],
                );
              }

              return Column(
                children: [
                  _mensajeChatBuild(
                    mensaje: _chat[index]["mensaje"],
                    tipo: _chat[index]["autor"]
                  ),

                  _chat[index]["anexos"] != null ?
                    _formatoCartaNombramientoBuild(_chat[index]["anexos"]) :
                    Container(),
                ],
              );
            }
          ),
        ),
        Flexible(flex: 1, child: Container()),
      ],
    );
  }

  Widget _formatoCartaNombramientoBuild(String anexos) {
    Color bubbleBackgroundColor;
    Color bubbleShadowColor;
    Color fontColor;
    FontWeight fontWeight;
    BorderRadius bubbleBorderRadius;
    bool editable;
    bool writting;

    bubbleBackgroundColor = Colors.white;
    bubbleShadowColor = HexColor("#C8C8C8").withOpacity(0.5);
    fontColor = HexColor("#4F5351");
    fontWeight = null;
    bubbleBorderRadius = BorderRadius.circular(20.0);
    editable = false;
    writting = false;

    return GestureDetector(
      onTap: () async {
        dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatSubirPoliza.Opcione>(
            builder: (BuildContext context) {
              return SimplePdfViewerWidget(
                completeCallback: (bool result){
                  print("completeCallback,result:${result}");
                },
                initialUrl: anexos,
              );
            },
          fullscreenDialog: true
        ));
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: bubbleBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: bubbleShadowColor,
                    spreadRadius: 0,
                    blurRadius: ScreenUtil().setHeight(5),
                    offset: Offset(0, ScreenUtil().setHeight(2)), 
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bubbleBackgroundColor,
                  borderRadius: bubbleBorderRadius,
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/Chat_Acrobat_PDF.png', filterQuality: FilterQuality.high, scale: 6,),
                    SizedBox(width: 10,),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil.screenWidth * 0.6,
                      ),
                      child: !writting ?
                        Text(
                          "Carta Nombramiento.pdf",
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: fontWeight,
                            color: fontColor,
                          )
                        ) : JumpingDotsProgressIndicator(
                          numberOfDots: 3,
                          fontSize: 10.0,
                          color: Color(0xFF4F5351),
                        ),
                    ),
                  ],
                ),
              )
            ),

            editable ? 
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Container(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(0.0),
                    icon: Image.asset('assets/images/Edit_Message.png', filterQuality: FilterQuality.high,)
                  ),
                ),
              ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _mensajeChatBuild({String mensaje, String tipo}) {
    Color bubbleBackgroundColor;
    Color bubbleShadowColor;
    Color fontColor;
    FontWeight fontWeight;
    BorderRadius bubbleBorderRadius;
    bool editable;
    bool writting;

    if ( tipo.toLowerCase() == "usuario" ) {
      bubbleBackgroundColor = HexColor("##0079DE");
      bubbleShadowColor = HexColor("##0079DE");
      fontColor = Colors.white;
      fontWeight = FontWeight.w500;
      bubbleBorderRadius = BorderRadius.only(
        topLeft:  Radius.circular(20.0),
        topRight: Radius.circular(20.0),
        bottomLeft:  Radius.circular(20.0)
      );
      editable = true;
      writting = false;
    } else {
      bubbleBackgroundColor = Colors.white;
      bubbleShadowColor = HexColor("#C8C8C8").withOpacity(0.5);
      fontColor = HexColor("#4F5351");
      fontWeight = null;
      bubbleBorderRadius = BorderRadius.circular(20.0);
      editable = false;
      writting = mensaje == "...";
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0
      ),
      child: Row(
        mainAxisAlignment: tipo.toLowerCase() == "usuario" ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: bubbleBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: bubbleShadowColor,
                  spreadRadius: 0,
                  blurRadius: ScreenUtil().setHeight(5),
                  offset: Offset(0, ScreenUtil().setHeight(2)), 
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bubbleBackgroundColor,
                borderRadius: bubbleBorderRadius,
              ),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil.screenWidth * 0.6,
                    ),
                    child: !writting ?
                      Text(
                        mensaje,
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: fontWeight,
                          color: fontColor,
                        )
                      ) : JumpingDotsProgressIndicator(
                        numberOfDots: 3,
                        fontSize: 10.0,
                        color: Color(0xFF4F5351),
                      ),
                  ),
                ],
              ),
            )
          ),

          editable ? 
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Container(
                height: 25,
                width: 25,
                child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0.0),
                  icon: Image.asset('assets/images/Edit_Message.png', filterQuality: FilterQuality.high,)
                ),
              ),
            ) : Container(),
        ],
      ),
    );
  }

  AppBar _appBarFirmaDigitalBuild() {
    return AppBar(
      leading: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.all(0.0),
          icon: Image.asset('assets/images/Back.png', filterQuality: FilterQuality.high,)
        ),
      ),
      centerTitle: true,
      title: Text(
        'Firma Digital',
        style: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: ScreenUtil().setSp(18),
          fontWeight: FontWeight.w500,
          color: Color(0xFF202D39)
        ),
      ),
      iconTheme: IconThemeData(
        color: HexColor("#202D39"),
      ),
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      elevation: 0.5,
    );
  }

  AppBar _appBarChatBuild() {
    return AppBar(
      leading: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
          padding: EdgeInsets.all(0.0),
          icon: Image.asset('assets/images/Back.png', filterQuality: FilterQuality.high,)
        ),
      ),
      iconTheme: IconThemeData(
        color: HexColor("#202D39"),
      ),
      backgroundColor: HexColor("#FCFBFF"),
      bottomOpacity: 0.0,
      elevation: 0.0,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context, 
                builder: (context) {
                  return Container(
                    color: Color(0xFF737373),
                    height: 800,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(48),),
                          Expanded(
                            child: Image.asset('assets/images/Support_Icon.png', width: ScreenUtil().setWidth(212)),
                          ),

                          SizedBox(height: ScreenUtil().setHeight(32),),
                          Material(
                            type: MaterialType.transparency,
                            child: Container(
                              height: ScreenUtil().setHeight(46),
                              width: double.infinity,
                              // color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Contactar a un asesor',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro', 
                                    fontSize: ScreenUtil().setSp(22), 
                                    color: HexColor("#202D39"), 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ScreenUtil().setHeight(18),),
                          Material(
                            type: MaterialType.transparency,
                            child: Container(
                              height: ScreenUtil().setHeight(60),
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(51)),
                              child: Center(
                                child: Text(
                                  'Te asignaremos un asesor para resolver \ntus dudas.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro', 
                                    fontSize: ScreenUtil().setSp(15), 
                                    color: HexColor("#5A666F"), 
                                  )
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 26,),
                          Container(
                            height: ScreenUtil().setHeight(60),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('chat_detail');
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                              disabledColor: HexColor("#C4C4C4"),
                              textColor: Colors.white,
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: HexColor("#C4C4C4"),
                                  gradient: LinearGradient(
                                    colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Container(
                                  // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                  width: ScreenUtil().setWidth(312),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Iniciar Chat",
                                    style: TextStyle(
                                      fontFamily: 'SF Pro', 
                                      fontSize: ScreenUtil().setSp(15), 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: ScreenUtil().setHeight(16),),
                          Container(
                            width: ScreenUtil().setWidth(350),
                            height: ScreenUtil().setHeight(44),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: 'Cerrar',
                                style: TextStyle(
                                  color: HexColor("#0079DE"), 
                                  fontSize: ScreenUtil().setSp(15),
                                  fontFamily: 'SF Pro', 
                                  fontWeight: FontWeight.bold
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                    statusBarColor: HexColor("#F9FAFA"),
                                    statusBarIconBrightness: Brightness.dark,
                                    statusBarBrightness: Brightness.light,
                                    systemNavigationBarColor: HexColor("#F9FAFA"),
                                    systemNavigationBarDividerColor: Colors.grey,
                                    systemNavigationBarIconBrightness: Brightness.dark,
                                  ));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular( ScreenUtil().setWidth(20) ),
                          topRight: Radius.circular( ScreenUtil().setWidth(20) ),
                        )
                      ),
                    ),
                  );
                }
              );
            },
            padding: EdgeInsets.all(0.0),
            icon: Image.asset('assets/images/Chatbot_Support.png', filterQuality: FilterQuality.high,)
          )
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
            onPressed: _chat.where((element) => element["autor"] == "Usuario").length == 0 ?  null : () async {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: MaterialLocalizations.of(context)
                    .modalBarrierDismissLabel,
                barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                  return MessageInfo(
                    // icon: MdiIcons.alertCircleOutline,
                    icon: 'assets/images/Restart_Icon.png',
                    iconColor: HexColor("#FA5858"),
                    title: '¿Volver a empezar?',
                    message: 'Esto borrará todas sus respuestas para iniciar nuevamente.',
                    onTap: () {
                      indexPregunta = 0;
                      _chat = [];
                      agregarPolizaData = {
                        "aseguradora": null,
                        "tipoPoliza": null,
                        "nroPoliza": null
                      };

                      contratarPolizaData = {
                        "aseguradora": null,
                        "tipoPoliza": null,
                        "nroPoliza": null,
                        "codigoPostal": null,
                        "year": null,
                        "marca": null,
                        "modelo": null,
                        "formaPago": null,
                      };
                      showDataEntry = false;
                      setState(() {});

                      initChat();
                      Navigator.of(context).pop();
                    },
                    cerrarBtn: true,
                  );
                }
              );
            },
            padding: EdgeInsets.all(0.0),
            icon: Image.asset('assets/images/Chatbot_Restart.png', filterQuality: FilterQuality.high,)
          )
        ),
      ],
    );
  }
}

class HandSignatureLine extends CustomPainter { 
  final double width;
  final double stroke;
  
  HandSignatureLine(this.width, this.stroke);
  
  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.lines;
    final points = [
      Offset(0, 0),
      Offset(width, 0),
    ];
    final paint = Paint()
      ..color = Color(0xFF979797).withOpacity(0.3)
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}