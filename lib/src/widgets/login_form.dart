import 'dart:convert';
import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/services/preferences_service.dart';
// import 'package:brokfy_app/src/widgets/country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'boton_sos.dart';
import 'country_code_picker/country_code.dart';
import '../widgets/country_code_picker/country_code_picker.dart';
import 'hex_color.dart';
import 'input_field.dart';
import 'message_info.dart';
import 'procesando.dart';

class LoginForm extends StatefulWidget {

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _passwordController;
  TextEditingController _phoneController;
  bool _obscureText;
  bool _recuerdame;
  bool _passwordError;
  bool _passwordValido;
  bool _phoneValido;
  bool _phoneError;
  MaskTextInputFormatter maskFormatter;
  PreferencesService _pref; 
  bool running = false;
  CountryCode countryCode;

  @override
  void initState() {
    _pref = PreferencesService();
    _passwordController = new TextEditingController();
    _phoneController = new TextEditingController();
    _obscureText = true;
    _recuerdame = false;
    _passwordValido = false;
    _passwordError = false;
    _phoneValido = false;
    _phoneError = false;
    maskFormatter = new MaskTextInputFormatter(mask: '(##) #### ## ##', filter: { "#": RegExp(r'[0-9]') });

    // _phoneController.text = '56933110846';
    // _passwordController.text = 'Andres\$123';
    // _phoneValido = true;
    // _passwordValido = true;

    _passwordController.addListener(_validatePassword);
    _phoneController.addListener(_validatePhoneNumber);
    countryCode = CountryCode(code: "MX", flagUri: "assets/images/flags/MX.png", dialCode: "+52", name: "México");

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }  

  _validatePassword() {
    setState(() {
      _passwordValido = _passwordController.text.length >= 6;
      _passwordError = _passwordController.text.length >= 6 ? false : true;
    });
  }

  _validatePhoneNumber() {
    setState(() {
      // _phoneValido = maskFormatter.getUnmaskedText().length == 10;
      // _phoneError = maskFormatter.getUnmaskedText().length == 10 ? false : true;

      _phoneValido = _phoneController.text.length >= 9;
      _phoneError = !_phoneValido;
    });
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    var telefono = maskFormatter.getUnmaskedText() == "" ? _phoneController.text : maskFormatter.getUnmaskedText();
    telefono = '${countryCode.dialCode.replaceAll("+", "")}$telefono';
    var password = _passwordController.text;

    try {

      setState(() {
        running = true;
      });
      
      // intenta hacer login
      AuthApiResponse authResponse = await ApiService.login(telefono, password);

      // Grabar el acceso en sharedpreferences
      _pref.isLogged = true;

      // Grabar los datos principales en SqlLite
      authResponse.password = base64Encode(utf8.encode(password));
      await DBService.db.insertAuth(authResponse);

      // AuthApiResponse prueba = await DBService.db.getAuthFirst();

      setState(() {
        running = false;
      });

      // Se muestra un mensaje 

      // Redirecciona al home
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
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
          return MessageInfo(
            // icon: MdiIcons.alertCircleOutline,
            icon: 'assets/images/Error_Icon.png',
            iconColor: HexColor("#FA5858"),
            title: e.message == "User is disabled" ? 
              'Usuario bloqueado' : 
              'Credenciales Inválidas',
            message: e.message == "User is disabled" ? 
              "El usuario se encuentra bloqueado por multiples intentos fallidos." :
              'Después de tres intentos la cuenta quedará bloqueada.',
            onTap: () {
              Navigator.of(context).pop();
            },
          );
        }
      );
    }
    // Navigator.pushReplacementNamed(context, 'home');
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(82),
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
            top: ScreenUtil().setHeight(97),
          ),
          child: Row(
            children: [
              Text(
                'Bienvenido!',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                  color: HexColor("#202D39"),
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
              Expanded(child: BotonSOS(),),
            ],
          ),
        ),

        Container(
          height:ScreenUtil().setHeight(96), 
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
            top: ScreenUtil().setHeight(36),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenUtil().setHeight(40),
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10)
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'País',
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: ScreenUtil().setSp(14),
                        color: HexColor("#5A666F"),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: false,
                    child: Container(
                      height: ScreenUtil().setHeight(55),
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setHeight(12), 
                        right: ScreenUtil().setWidth(8),
                        left: ScreenUtil().setWidth(8),
                        top: ScreenUtil().setHeight(6),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Colors.black,
                            width: ScreenUtil().setHeight(1),
                          ),
                        ),
                      ),
                      child: CountryCodePicker(
                        onChanged: (CountryCode code) {
                          setState(() {
                            countryCode = code;
                          });
                        },
                        initialSelection: 'MX',
                        // favorite: ['MX'],
                        // countryFilter: ['MX'],
                        showFlagDialog: true,
                        showCountryOnly: true,
                        comparator: (a, b) => b.name.compareTo(a.name),
                        // onInit: (code) => print("on init ${code.name} ${code.dialCode} ${code.name}"),
                        showFlagMain: true,
                        showFlag: true,
                        hideSearch: false,
                        textStyle: TextStyle(
                          fontFamily: 'SF Pro',
                          color: HexColor("#202D39"),
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold
                        ),
                        searchStyle: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.w600,
                          color: HexColor("#202D39"),
                        ),
                        dialogTextStyle: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.w600,
                          color: HexColor("#202D39"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(width: ScreenUtil().setWidth(20),),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(90),
                  margin: EdgeInsets.only(
                    // left: ScreenUtil().setWidth(40),
                    // right: ScreenUtil().setWidth(41),
                    // top: ScreenUtil().setHeight(36),
                  ),
                  child: InputField(
                    keyboardType: TextInputType.phone,
                    // maskFormatter: maskFormatter, 
                    controller: _phoneController, 
                    valido: _phoneValido, 
                    error: _phoneError,
                    label: 'Teléfono',
                    placeholder: '(55) 5555 55 55 ',
                    obscureText: false,
                    showSuffixIcon: true,
                  ),
                ),
              ),
            ],
          ),
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
            obscureText: _obscureText,
            showSuffixIcon: true,
          ),
        ),

        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(26),
            right: ScreenUtil().setWidth(41),
            top: ScreenUtil().setHeight(18),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _recuerdame,
                onChanged: (bool value) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _recuerdame = value;
                  });
                }
              ),
              Text(
                'Recuerdame',
                style: TextStyle(
                  color: HexColor("#5A666F"), 
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(14),
                  fontFamily: 'SF Pro', 
                ),
              ),
              Expanded(child: Container()),
              RichText(
                text: TextSpan(
                  text: 'Recuperar contraseña',
                  style: TextStyle(
                    color: HexColor("#0079DE"),
                    fontFamily: 'SF Pro', 
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(context, 'recuperar');
                      },
                ),
              ),
            ],
          ),
        ),

        Container(
          height: ScreenUtil().setHeight(60),
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
            top: ScreenUtil().setHeight(36),
          ),
          decoration: _phoneValido && _passwordValido && !running ? BoxDecoration(
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
            onPressed: _phoneValido && _passwordValido && !running ? _login : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            splashColor: Color.fromRGBO(255, 255, 255, 0.2),
            disabledColor: HexColor("#C4C4C4"),
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                color: HexColor("#C4C4C4"),
                gradient: _phoneValido && _passwordValido && !running ? LinearGradient(
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
                  "Iniciar Sesión",
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
        ),

        Container(
          height: 80.0,
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
            top: ScreenUtil().setHeight(36),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                'Nuevo a Brokfy?',
                style: TextStyle(
                  color: HexColor("#5A666F"),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(14),
                  fontFamily: 'SF Pro', 
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              RichText(
                text: TextSpan(
                  text: 'Crear una cuenta',
                  style: TextStyle(
                    color: HexColor("#0079DE"),
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(14),
                    fontFamily: 'SF Pro', 
                  ),
                  recognizer: TapGestureRecognizer()
                      ..onTap = () { 
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(context, "crear_usuario");
                      }
                ),
              ),
            ],
          ),
        ),

        Container(
          color: Colors.transparent,
          height: 100,
        )
      ],
    );
  }
}