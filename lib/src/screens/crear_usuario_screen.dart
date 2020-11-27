import 'package:brokfy_app/src/models/verificar_numero_response.dart';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import '../widgets/country_code_picker/country_code_picker.dart';
import '../widgets/country_code_picker/country_code.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/input_field.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
// import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class CrearUsuarioScreen extends StatefulWidget {
  @override
  _CrearUsuarioScreenState createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController;
  bool _emailValido;
  bool _emailError;
  TextEditingController _phoneController;
  bool _phoneValido;
  bool _phoneError;
  TextEditingController _passwordController;
  bool _passwordError;
  bool _passwordValido;
  bool _obscureText;
  MaskTextInputFormatter maskFormatter;
  bool running;
  CountryCode countryCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailValido = false;
    _emailError = false;
    _phoneController = new TextEditingController();
    _phoneValido = false;
    _phoneError = false;
    _passwordController = new TextEditingController();
    _passwordValido = false;
    _passwordError = false;
    _obscureText = true;
    running = false;
    maskFormatter = new MaskTextInputFormatter(mask: '(##) #### ## ##', filter: { "#": RegExp(r'[0-9]') });
    // maskFormatter = new MaskTextInputFormatter(mask: '(##) # #### ####', filter: { "#": RegExp(r'[0-9]') });

    // INI TEMP
    // _emailController.text = 'hapsa10@gmail.com';
    // _emailValido = true;
    // FIN TEMP

    _emailController.addListener(_validateEmail);
    _phoneController.addListener(_validatePhoneNumber);
    _passwordController.addListener(_validatePassword);

    countryCode = CountryCode(code: "MX", flagUri: "assets/images/flags/MX.png", dialCode: "+52", name: "México");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CrearUsuarioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  _validateEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    
    setState(() {
      _emailValido = (!regex.hasMatch(_emailController.text)) ? false : true;
      _emailError = !_emailValido;
    });
  }

  _validatePhoneNumber() {
    setState(() {
      // _phoneValido = maskFormatter.getUnmaskedText().length >= 9;
      // _phoneError = maskFormatter.getUnmaskedText().length >= 9 ? false : true;
      _phoneValido = _phoneController.text.length >= 9;
      _phoneError = !_phoneValido;
      
    });
  }

  _validatePassword() {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);

    setState(() {
      _passwordValido = regExp.hasMatch(_passwordController.text);
      _passwordError = !regExp.hasMatch(_passwordController.text);
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
        key: _scaffoldKey,
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
                  'Crear Nuevo Usuario',
                  style: TextStyle(
                    color: HexColor("#202D39"),
                    fontSize: ScreenUtil().setSp(30),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro'
                  ),
                ),
              ),  

              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(90),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(46),
                ),
                child: InputField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController, 
                  valido: _emailValido, 
                  error: _emailError,
                  label: 'Correo electrónico',
                  placeholder: 'Escribe tu correo electrónico',
                  obscureText: false,
                  showSuffixIcon: true,
                ),
              ),

              Container(
                height:ScreenUtil().setHeight(96), 
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(26),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
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
                  top: ScreenUtil().setHeight(26),
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
                height: ScreenUtil().setHeight(60),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(62),
                ),
                decoration: _emailValido && _passwordValido && _phoneValido && !running ? BoxDecoration(
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
                  onPressed: _emailValido && _passwordValido && _phoneValido && !running ? () async {
                    FocusScope.of(context).unfocus();

                    nuevoUsuario.limpiarUsuario();

                    nuevoUsuario.email = _emailController.text;
                    // nuevoUsuario.telefono = maskFormatter.getUnmaskedText();
                    nuevoUsuario.telefono = _phoneController.text;
                    nuevoUsuario.pais = countryCode.dialCode;
                    nuevoUsuario.password = _passwordController.text;

                    try {
                      setState(() {
                        running = true;
                      });

                      VerificarNumeroResponse apiResponse = await ApiService.verificarNumeroCelular('${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}', nuevoUsuario.email);
                      if( apiResponse.error != null && apiResponse.error == true ) {
                        if( apiResponse.message == "Usuario se encuentra registrado!" || apiResponse.message == "Ya existe una cuenta registrada con ese correo." ) {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                              return MessageInfo(
                                icon: 'assets/images/Error_Icon.png',
                                iconColor: HexColor("#333333"),
                                title: "Error de Registro",
                                message: apiResponse.message == "Usuario se encuentra registrado!" ? "Ya existe una cuenta registrada con ese teléfono." : apiResponse.message,
                                accion: "Iniciar Sesión",
                                cerrarBtn: true,
                                onTap: () {
                                  var navigator = Navigator.of(context);
                                  var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
                                  navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
                                  navigator.pushReplacementNamed("login");
                                },
                              );
                            }
                          );
                        } else {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
                              return MessageInfo(
                                icon: 'assets/images/Error_Icon.png',
                                iconColor: HexColor("#333333"),
                                title: "Error de Registro",
                                message: apiResponse.message,
                                accion: "Reintentar",
                                onTap: () {
                                  Navigator.of(context).pop();
                                  // setState(() {
                                  //   _phoneController.text = '';
                                  // });
                                },
                              );
                            }
                          );
                        }
                      } else if ( apiResponse.id == null ) {

                      } else {
                        nuevoUsuario.idVerificacionNumero = apiResponse.id;
                        Navigator.pushNamed(context, 'verificacion');
                      }
                    } catch (e) {
                      // print(e.toString());
                    }

                    setState(() {
                      running = false;
                    });
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
                      gradient: _emailValido && _passwordValido && _phoneValido && !running ? LinearGradient(
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
                          fontSize: ScreenUtil().setSp(15), 
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro', 
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50,),
            ],
          ),
        )
      ),
    );
  }
}
