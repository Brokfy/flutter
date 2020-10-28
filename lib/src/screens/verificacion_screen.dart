import 'package:brokfy_app/src/models/verificar_numero_response.dart';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificacionScreen extends StatefulWidget {
  @override
  _VerificacionScreenState createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  String _code;
  bool _pinValido;
  bool _pinError;
  bool _expirado;
  UniqueKey keyCountdown;
  String mensajeError;
  bool running;

  @override
  void initState() {
    super.initState();
    _pinValido = false;
    _pinError = false;
    _expirado = false;
    _code = "";
    keyCountdown = UniqueKey();
    mensajeError = "";
    running = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updatePin(String code) {
    setState(() {
      _code = code;
      _pinValido = code.length == 6;
    });
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
    final nuevoUsuario = Provider.of<NuevoUsuario>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F9FAFA"),
        appBar: AppBar(
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
          iconTheme: IconThemeData(
            color: HexColor("#202D39"),
          ),
          backgroundColor: HexColor("#F9FAFA"),
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(), 
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(36),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Verificación',
                  style: TextStyle(
                    color: HexColor("#202D39"),
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),  

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                ),
                child: Text(
                  'Por favor ingrese los 6 dígitos que le enviamos via SMS para verificar su número de teléfono.',
                  style: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w400
                  )
                ),
              ),

              !_pinValido && _pinError ? 
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    bottom: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                  ),
                  child: Text(
                    mensajeError,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(15),
                      color: HexColor("#FF666A"),
                      fontWeight: FontWeight.w500
                    )
                  ),
                ) : Container( height: 30.0 ),

              Container(
                width: MediaQuery.of(context).size.width,
                // height: 40.0,
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(20),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                ),
                child: PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: ScreenUtil().setSp(30), 
                      color: Colors.black
                    ),
                    color: Colors.black,
                    lineHeight: ScreenUtil().setHeight(1)
                  ),
                  currentCode: _code,
                  onCodeSubmitted: (code) {
                    // print(code);
                  },
                  onCodeChanged: (code) {
                    if( code != _code ) {
                      _updatePin(code);
                    }
                    if (code.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(60),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "código expira en: ",
                      style: TextStyle(
                        inherit: true,
                        fontFamily: 'SF Pro',
                        fontSize: ScreenUtil().setSp(16)
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      width: ScreenUtil().setWidth(66),
                      child: Builder(builder: (context) {
                        return CountdownFormatted(
                          key: keyCountdown,
                          onFinish: () {
                            setState(() {
                              _expirado = true;
                            });
                          },
                          duration: Duration(minutes: 5),
                          builder: (BuildContext ctx, String remaining) {
                            return Text(
                              remaining,
                              style: TextStyle(
                                inherit: true,
                                fontFamily: 'SF Pro',
                                fontSize: ScreenUtil().setSp(16),
                                color: remaining.startsWith("00:") ? Colors.red : null,
                              ),
                            ); // 01:00:00
                          },
                        );
                      },),
                    ),
                  ],
                ),
              ),

              Container(
                height: ScreenUtil().setHeight(60),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(62),
                ),
                decoration: _code.length == 6 && !_expirado && !running ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#0079DE").withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: ScreenUtil().setHeight(9),
                      offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
                    ),
                  ],
                ) : null,
                child: RaisedButton(
                  onPressed: _code.length == 6 && !_expirado && !running ? () async {
                    FocusScope.of(context).unfocus();

                    if ( nuevoUsuario.idVerificacionNumero != "" ) {
                      try {
                        setState(() {
                          running = true;
                        });
                        
                        VerificarNumeroResponse apiResponse = await ApiService.validarCodigoVerificacionIngresado(nuevoUsuario.idVerificacionNumero, this._code);

                        setState(() {
                          running = false;
                        });

                        if ( apiResponse.status.toString() == "0" ) {
                          _pinValido = true;
                          _pinError = false;

                          Navigator.pushNamed(context, 'datos_personales');
                        } else {
                          String mensaje = "";
                          switch (apiResponse.status.toString()) {
                            case "7":
                              mensaje = "El número celular ingresado no se puede verificar.";
                              break;
                            case "10":
                              mensaje = "El número celular ya ha sido verificado.";
                              break;
                            case "16":
                              mensaje = '¡Código incorrecto! Porfavor intenta de nuevo.';
                              break;
                            case "17":
                              mensaje = "Se ha ingresado varias veces un código errado.";
                              break;
                            default: 
                              mensaje = "No se pudo atender la solicitud.";
                              break;
                          }

                          setState(() {
                            _pinValido = false;
                            _pinError = true;
                            mensajeError = mensaje;
                          });
                        }
                      } catch (e) {}

                      setState(() {
                        running = false;
                      });
                    }
                    
                  } : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                  disabledColor: HexColor("#C4C4C4"),
                  textColor: Colors.white,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: HexColor("#C4C4C4"),
                      gradient: _code.length == 6 && !_expirado && !running ? LinearGradient(
                        colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ) : null,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Container(
                      // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: running ? Procesando() : Text(
                        "Continuar",
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

              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(40)
                  ),
                  child: Column(
                    children: [
                      Text(
                        'No recibiste el código?',
                        style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: ScreenUtil().setSp(15), 
                          color: HexColor("#5A666F")
                        )
                      ),
                      SizedBox(height: ScreenUtil().setHeight(2),),
                      RichText(
                        text: TextSpan(
                          text: 'Reenviar',
                          style: TextStyle(
                            color: _expirado ? HexColor("#0079DE") : Colors.grey, 
                            fontSize: ScreenUtil().setSp(15), 
                            fontFamily: 'SF Pro', 
                            fontWeight: FontWeight.bold
                          ),
                          recognizer: TapGestureRecognizer()
                              ..onTap = _expirado ? () async { 
                                FocusScope.of(context).unfocus();
                                try {
                                  VerificarNumeroResponse apiResponse = await ApiService.reenviarCodigoVerificacion('${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}', nuevoUsuario.idVerificacionNumero);
                                  nuevoUsuario.idVerificacionNumero = apiResponse.id;

                                  setState(() {
                                    keyCountdown = UniqueKey();
                                    _expirado = false;
                                    _code = "";
                                    mensajeError = "";
                                  });

                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: MaterialLocalizations.of(context)
                                        .modalBarrierDismissLabel,
                                    barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
                                    transitionDuration: const Duration(milliseconds: 200),
                                    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                                      return MessageInfo(
                                        // icon: MdiIcons.information,
                                        icon: 'assets/images/Verified_Icon.png',
                                        title: "Verificación",
                                        message: "Hemos reenviado un nuevo código via SMS.",
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                  );

                                  // showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) => CupertinoAlertDialog(
                                  //     title: Text(
                                  //       'Verificación',
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         fontSize: ScreenUtil().setSp(17),
                                  //       )
                                  //     ),
                                  //     content: Text(
                                  //       "Hemos reenviado un nuevo código via SMS.",
                                  //       style: TextStyle(
                                  //         fontSize: ScreenUtil().setSp(13),
                                  //       )
                                  //     ),
                                  //     actions: <Widget>[
                                  //       CupertinoDialogAction(
                                  //         onPressed: () {
                                  //           Navigator.of(context).pop();
                                  //         },
                                  //         isDefaultAction: true,
                                  //         child: Text(
                                  //           'Aceptar',
                                  //           style: TextStyle(
                                  //             color: HexColor("#007AFF"),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   )
                                  // );
                                } catch (e) {}
                              } : null
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        )
      )
    );
  }
}