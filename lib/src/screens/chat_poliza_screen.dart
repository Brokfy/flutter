import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/api_service.dart';
import '../models/chat_inicial_response.dart' as chatInicial;
import '../models/chat_subir_poliza_response.dart' as chatSubirPoliza;
import '../widgets/loading.dart';
import '../widgets/select_option_from_list.dart';
import '../widgets/jumping_dots_progress_indicator.dart';

class ChatPolizaScreen extends StatefulWidget {
  @override
  _ChatPolizaScreenState createState() => _ChatPolizaScreenState();
}

class _ChatPolizaScreenState extends State<ChatPolizaScreen> {
  List<chatInicial.Opcione> _opciones;
  bool loading;
  List<Map<String, String>> _chat = [];
  bool showDataEntry;
  String dataEntryType;
  List<chatSubirPoliza.ChatSubirPolizaResponse> _continuacionChat;
  int indexPregunta = 0;
  ScrollController _scrollController;
  bool writting;
  TextEditingController _nroPolizaController;
  Map<String, dynamic> agregarPolizaData = {
    "aseguradora": null,
    "tipoPoliza": null,
    "nroPoliza": null
  };

  @override
  void initState() {
    super.initState();
    loading = true;
    showDataEntry = false;
    writting = false;
    _scrollController = ScrollController();
    _nroPolizaController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nroPolizaController.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if( _chat.length == 0 ) {
      chatInicial.ChatInicialResponse _saludo = await ApiService.iniciarChat();
      _opciones = _saludo.opciones;
      loading = false;
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
    if( opcion.endpoint == "/subirPoliza" ) {
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
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

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
          dataEntryType == "nroAseguradora" ? _seleccionNroPolizaBuild() : 
          [],
      ),
    );
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
                        dataEntryType = "tipoPoliza";
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
            dynamic seleccion = await Navigator.of(context).push(new MaterialPageRoute<chatSubirPoliza.Opcione>(
                builder: (BuildContext context) {
                  return SelectOptionFromList(
                    _continuacionChat[indexPregunta].opciones,
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
              agregarPolizaData["tipoPoliza"] = seleccion;
              _chat.add({
                "mensaje": agregarPolizaData["tipoPoliza"].opcion,
                "autor": "Usuario"
              });
              showDataEntry = false;
              indexPregunta = _continuacionChat.indexWhere((element) => element.id == agregarPolizaData["tipoPoliza"].action);
              setState(() {});

              for (var pregunta in _continuacionChat[indexPregunta].preguntas) {
                writting = true;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 20 * pregunta.pregunta.length));

                writting = false;
                setState(() {});
                await Future.delayed(Duration(milliseconds: 200));

                _chat.add({
                  "mensaje": pregunta.pregunta.replaceAll("%s", agregarPolizaData["tipoPoliza"].opcion),
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
                return Column(
                  children: [
                    _mensajeChatBuild(
                      mensaje: _chat[index]["mensaje"],
                      tipo: _chat[index]["autor"]
                    ),

                    writting == true ?
                      _mensajeChatBuild(
                        mensaje: "...",
                        tipo: "Brokfy"
                      ) : Container(),
                  ],
                );
              }

              return 
              _mensajeChatBuild(
                mensaje: _chat[index]["mensaje"],
                tipo: _chat[index]["autor"]
              );
            }
          ),
        ),
        Flexible(flex: 1, child: Container()),
      ],
    );
    
    // SingleChildScrollView(
    //   controller: _scrollController,
    //   physics: BouncingScrollPhysics(), 
    //   child: Row(
    //     children: [
    //       Expanded(flex: 1, child: Container()),
    //       Expanded(flex: 8, child: Container(
    //         padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
    //         height: MediaQuery.of(context).size.height,
    //         child: Column(
    //           children: [
    //             ..._chat.map((msj) => _mensajeChatBuild(
    //                 mensaje: msj["mensaje"],
    //                 tipo: msj["autor"]
    //               )
    //             ),

    //             writting == true ?
    //               _mensajeChatBuild(
    //                 mensaje: "...",
    //                 tipo: "Brokfy"
    //               ) : Container(),
    //           ],
    //         )
    //       )),
    //       Expanded(flex: 1, child: Container()),
    //     ]
    //   )
    // );
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
            onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
            padding: EdgeInsets.all(0.0),
            icon: Image.asset('assets/images/Chatbot_Support.png', filterQuality: FilterQuality.high,)
          )
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: IconButton(
            // onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
            onPressed: () {
              setState(() {
                _chat.add({
                  "mensaje": "TEST",
                  "autor": "Brokfy"
                });
              });
            },
            padding: EdgeInsets.all(0.0),
            icon: Image.asset('assets/images/Chatbot_Restart.png', filterQuality: FilterQuality.high,)
          )
        ),
      ],
    );
  }
}