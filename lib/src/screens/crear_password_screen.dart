import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/screens/login_screen.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/image_from_assets.dart';
import 'package:brokfy_app/src/widgets/input_field.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

class CrearPasswordScreen extends StatefulWidget {
  @override
  _CrearPasswordScreenState createState() => _CrearPasswordScreenState();
}

class _CrearPasswordScreenState extends State<CrearPasswordScreen> {
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;
  bool _passwordValido;
  bool _passwordError;
  bool _passwordConfirmValido;
  bool _passwordConfirmError;
  // ignore: unused_field
  bool _obscureTextPassword;
  // ignore: unused_field
  bool _obscureTextPasswordConfirm;
  bool running;

  @override
  void initState() {
    super.initState();

    _passwordValido = false;
    _passwordError = false;
    _passwordConfirmValido = false;
    _passwordConfirmError = false;
    _obscureTextPassword = true;
    _obscureTextPasswordConfirm = true;
    running = false;

    _passwordController = new TextEditingController();
    _passwordConfirmController = new TextEditingController();

    _passwordController.addListener(_validatePassword);
    _passwordConfirmController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }  

  _validatePassword() {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    
    print(regExp.hasMatch(_passwordController.text));
    
    setState(() {
      _passwordValido = regExp.hasMatch(_passwordController.text);
      _passwordError = !regExp.hasMatch(_passwordController.text);
      _passwordConfirmValido = regExp.hasMatch(_passwordController.text) && _passwordConfirmController.text == _passwordController.text;
      _passwordConfirmError = regExp.hasMatch(_passwordController.text) && _passwordConfirmController.text == _passwordController.text ? false : true;
    });
  }

  _validateConfirmPassword() {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);

    setState(() {
      _passwordConfirmValido = regExp.hasMatch(_passwordController.text) && _passwordConfirmController.text == _passwordController.text;
      _passwordConfirmError = regExp.hasMatch(_passwordController.text) && _passwordConfirmController.text == _passwordController.text ? false : true;
    });
  }

  Future<bool> _onWillPop() async {
    return (await 
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return MessageInfo(
            icon: 'assets/images/Restart_Icon.png',
            iconColor: HexColor("#333333"),
            title: "¿Cancelar cambio de \ncontraseña?",
            message: "Ningún cambio tendrá efecto.",
            accion: "Si, Cancelar",
            cerrarBtn: true,
            onTap: () {
              var navigator = Navigator.of(context);
              var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
              navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
              navigator.pushReplacementNamed("login");
            },
          );
        }
      )
    
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) => CupertinoAlertDialog(
      //     title: Text(
      //       'Cancelar el cambio de contraseña',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         fontSize: ScreenUtil().setSp(17),
      //       )
      //     ),
      //     content: Text(
      //       "¿Realmente desea cancelar el cambio de contraseña?",
      //       style: TextStyle(
      //         fontSize: ScreenUtil().setSp(13),
      //       )
      //     ),
      //     actions: <Widget>[
      //       CupertinoDialogAction(
      //         onPressed: () {
      //           Navigator.of(context).pop(false);
      //         },
      //         isDefaultAction: true,
      //         child: Text(
      //           'No',
      //           style: TextStyle(
      //             color: HexColor("#007AFF"),
      //           ),
      //         ),
      //       ),
      //       CupertinoDialogAction(
      //         onPressed: () {
      //           Navigator.of(context).pop(false);

      //           var navigator = Navigator.of(context);
      //           var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
      //           navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
      //           navigator.pushReplacementNamed("login");
      //         },
      //         isDefaultAction: true,
      //         child: Text(
      //           'Si',
      //           style: TextStyle(
      //             color: HexColor("#007AFF"),
      //           ),
      //         ),
      //       ),
      //     ],
      //   )
      // )
    ) ?? false;
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
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: HexColor("#F9FAFA"),
          appBar: AppBar(
            leading: Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
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
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(81),
                  ),
                  child: ImageFromAssets( assetName: 'password', width: ScreenUtil().setWidth(174) ),
                ),

                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(90),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                    top: ScreenUtil().setHeight(36),
                  ),
                  child: InputField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController, 
                    valido: _passwordValido, 
                    error: _passwordError,
                    label: 'Contraseña',
                    placeholder: 'Escribe tu contraseña',
                    obscureText: true,
                    showSuffixIcon: true,
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(90),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                    top: ScreenUtil().setHeight(18),
                  ),
                  child: InputField(
                    keyboardType: TextInputType.text,
                    controller: _passwordConfirmController, 
                    valido: _passwordConfirmValido, 
                    error: _passwordConfirmError,
                    label: 'Confirmar Contraseña',
                    placeholder: 'Confirma tu contraseña',
                    obscureText: true,
                    showSuffixIcon: true,
                  ),
                ),

                Container(
                  height: ScreenUtil().setHeight(60),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                    top: ScreenUtil().setHeight(36),
                  ),
                  decoration: _passwordConfirmValido && _passwordValido && !running ? BoxDecoration(
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
                    onPressed: _passwordConfirmValido && _passwordValido && !running ? () async {
                      FocusScope.of(context).unfocus();
                      
                      try {
                        setState(() {
                          running = true;
                        });

                        if ( await ApiService.cambiarPassword('${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}', _passwordController.text) ) {
                          setState(() {
                            running = false;
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
                                // icon: MdiIcons.checkCircleOutline,
                                icon: 'assets/images/Verified_Icon.png',
                                iconColor: HexColor("#1BD55E"),
                                title: 'Cambio de contraseña',
                                message: "Tu contraseña se ha cambiado con éxito. Porfavor ingresa con tu nueva contraseña.",
                                onTap: () {
                                  Navigator.of(context).pop();

                                  var navigator = Navigator.of(context);
                                  var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
                                  navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
                                  navigator.pushReplacementNamed("login");
                                },
                              );
                            }
                          );
                        }
                      } catch (e) {
                        setState(() {
                          running = false;
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
                              // icon: MdiIcons.alertCircleOutline,
                              icon: 'assets/images/Error_Icon.png',
                              iconColor: HexColor("#FA5858"),
                              title: 'Error',
                              message: "No se pudo actualizar el password.",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        );
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
                        gradient: _passwordConfirmValido && _passwordValido && !running ? LinearGradient(
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
                          "Cambiar Contraseña",
                          style: TextStyle(
                            color: HexColor("#FFFFFF"),
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,)
              ]
            )
          )
        ),
      ),
    );
  }
}