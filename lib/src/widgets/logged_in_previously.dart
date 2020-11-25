import 'dart:convert';
import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/services/preferences_service.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'foto_usuario.dart';
import 'hex_color.dart';
import 'input_field.dart';
import 'message_info.dart';

class LoggedInPreviously extends StatefulWidget {
  final AuthApiResponse userInfo;

  const LoggedInPreviously({Key key, @required this.userInfo})
      : super(key: key);

  @override
  _LoggedInPreviouslyState createState() => _LoggedInPreviouslyState();
}

class _LoggedInPreviouslyState extends State<LoggedInPreviously> {
  TextEditingController _passwordController;
  bool _passwordValido;
  bool _passwordError;
  bool running;
  PreferencesService _pref;
  LocalAuthentication _localAuth;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    _passwordController = new TextEditingController();
    _passwordValido = false;
    _passwordError = false;
    running = false;
    _pref = PreferencesService();

    _localAuth = LocalAuthentication();
    _localAuth.canCheckBiometrics.then((value) {
      setState(() {
        _isBiometricAvailable = value;
        _leerHuella();
      });
    });

    _passwordController.addListener(_validatePassword);

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  _validatePassword() {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);

    setState(() {
      _passwordValido = regExp.hasMatch(_passwordController.text);
      _passwordError = !regExp.hasMatch(_passwordController.text);
    });
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    var telefono = this.widget.userInfo.username;
    var password = _passwordController.text;

    try {
      setState(() {
        running = true;
      });

      // intenta hacer login
      AuthApiResponse auth = await ApiService.login(telefono, password);
      auth.password = base64Encode(utf8.encode(password));
      await DBService.db.updateAuth(auth);

      // Grabar el acceso en sharedpreferences
      _pref.isLogged = true;

      setState(() {
        running = false;
      });

      Navigator.of(context).pushReplacementNamed('home');
    } catch (e) {
      // Se muestra un mensaje de error
      // print(e);

      setState(() {
        running = false;
      });

      showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return MessageInfo(
              // icon: MdiIcons.alertCircleOutline,
              icon: 'assets/images/Error_Icon.png',
              iconColor: HexColor("#FA5858"),
              title: e.message == "User is disabled"
                  ? 'Usuario bloqueado'
                  : 'Credenciales Inválidas',
              message: e.message == "User is disabled"
                  ? "El usuario se encuentra bloqueado por multiples intentos fallidos."
                  : 'Después de tres intentos el usuario se bloqueará. Intenta de nuevo',
              onTap: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
    // Navigator.pushReplacementNamed(context, 'home');
  }

  _leerHuella() async {
    try {
      if (_isBiometricAvailable) {
        bool didAuthenticate = await _localAuth.authenticateWithBiometrics(
            localizedReason: "Iniciar sesión con huella digital en Brokfy");
        if (didAuthenticate) {
          _pref.isLogged = false;
          AuthApiResponse user = await DBService.db.getAuthFirst();
          String password = utf8.decode(base64Decode(user.password));

          // intenta hacer login
          AuthApiResponse authResponse =
              await ApiService.login(user.username, password);
          authResponse.password = user.password;
          await DBService.db.insertAuth(authResponse);

          Navigator.pushReplacementNamed(context, "home");
        }
      }
    } catch (e) {
      await DBService.db.deleteAllAuth();
      Navigator.of(context).pushReplacementNamed('login');
    }
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

    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              // height: ScreenUtil().setHeight(82),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                right: ScreenUtil().setWidth(41),
                top: ScreenUtil().setHeight(97),
              ),
              child: FotoUsuario(url: widget.userInfo.nameAws)),
          Container(
              width: double.infinity,
              // height: ScreenUtil().setHeight(82),
              margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                right: ScreenUtil().setWidth(41),
                top: ScreenUtil().setHeight(27),
              ),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: 'Hola ',
                  style: DefaultTextStyle.of(context).style.copyWith(
                        inherit: true,
                        color: HexColor("#000000"),
                        fontSize: ScreenUtil().setSp(20),
                        fontFamily: 'SF Pro',
                      ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            "${widget.userInfo.nombre} ${widget.userInfo.apellidoPaterno}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'SF Pro')),
                  ],
                ),
              )),
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
            height: ScreenUtil().setHeight(60),
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(41),
              top: ScreenUtil().setHeight(36),
            ),
            decoration: _passwordValido && !running
                ? BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: HexColor("#0079DE").withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: ScreenUtil().setHeight(9),
                        offset: Offset(
                            0,
                            ScreenUtil()
                                .setHeight(3)), // changes position of shadow
                      ),
                    ],
                  )
                : null,
            child: RaisedButton(
              onPressed: _passwordValido && !running ? _login : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              splashColor: Color.fromRGBO(255, 255, 255, 0.2),
              disabledColor: HexColor("#C4C4C4"),
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    color: HexColor("#C4C4C4"),
                    gradient: _passwordValido && !running
                        ? LinearGradient(
                            colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Container(
                  // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: running
                      ? Procesando()
                      : Text(
                          "Inicia Sesión",
                          style: TextStyle(
                            color: HexColor("#FFFFFF"),
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(60),
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(41),
              top: ScreenUtil().setHeight(36),
            ),
            child: RichText(
              text: TextSpan(
                  text: 'No eres ${this.widget.userInfo.nombre}?',
                  style: TextStyle(
                      color: HexColor("#0079DE"),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(14),
                      fontFamily: 'SF Pro'),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      FocusScope.of(context).unfocus();
                      await DBService.db.deleteAllAuth();
                      Navigator.of(context).pushReplacementNamed('login');
                    }),
            ),
          ),
        ]);
  }
}
