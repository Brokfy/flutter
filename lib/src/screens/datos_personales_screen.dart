import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/screens/login_screen.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/widgets/date_field.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/input_field.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:brokfy_app/src/widgets/radio_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DatosPersonalesScreen extends StatefulWidget {
  @override
  _DatosPersonalesScreenState createState() => _DatosPersonalesScreenState();
}

class _DatosPersonalesScreenState extends State<DatosPersonalesScreen> {
  TextEditingController _nombreController;
  bool _nombreValido;
  bool _nombreError;
  TextEditingController _apellidoPaternoController;
  bool _apellidoPaternoValido;
  bool _apellidoPaternoError;
  TextEditingController _apellidoMaternoController;
  bool _apellidoMaternoValido;
  bool _apellidoMaternoError;
  TextEditingController _fechaNacimientoController;
  bool _fechaNacimientoValido;
  // ignore: unused_field
  bool _fechaNacimientoError;
  String _sexo;
  String _fechaNacimiento;
  bool running;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _nombreValido = false;
    _nombreError = false;
    _apellidoPaternoController = TextEditingController();
    _apellidoPaternoValido = false;
    _apellidoPaternoError = false;
    _apellidoMaternoController = TextEditingController();
    _apellidoMaternoValido = false;
    _apellidoMaternoError = false;
    _fechaNacimientoController = TextEditingController();
    _fechaNacimientoValido = false;
    _fechaNacimientoError = false;
    _sexo = "Masculino";
    _fechaNacimiento = "";
    running = false;

    // INI TEMP
    // _nombreController.text = "Hamid";
    // _nombreValido = true;
    // _apellidoPaternoController.text = "Pinilla";
    // _apellidoPaternoValido = true;
    // _apellidoMaternoController.text = "Saah";
    // _apellidoMaternoValido = true;
    // _fechaNacimientoController.text = "18 de Agosto de 2020";
    // _fechaNacimiento = "2020-08-18";
    // FIN TEMP

    _nombreController.addListener(_validateNombre);
    _apellidoPaternoController.addListener(_validateApellidoPaterno);
    _apellidoMaternoController.addListener(_validateApellidoMaterno);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  _validateNombre() {
    setState(() {
      _nombreValido = _nombreController.text.length >= 4;
      _nombreError = _nombreController.text.length >= 4 ? false : true;
    });
  }

  _validateApellidoPaterno() {
    setState(() {
      _apellidoPaternoValido = _apellidoPaternoController.text.length >= 4;
      _apellidoPaternoError = _apellidoPaternoController.text.length >= 4 ? false : true;
    });
  }

  _validateApellidoMaterno() {
    setState(() {
      _apellidoMaternoValido = _apellidoMaternoController.text.length >= 4;
      _apellidoMaternoError = _apellidoMaternoController.text.length >= 4 ? false : true;
    });
  }

  _selectDateFechaNacimiento(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1920),
      lastDate: new DateTime.now(),
      locale: Locale('es')
    );

    if( picked != null ) {
      setState(() {
        final fMes = new DateFormat("MMMM", 'es');
        final fDia = new DateFormat("dd", 'es');
        final fAno = new DateFormat("yyyy", 'es');
        final fFecha = new DateFormat("yyyy-MM-dd", 'es');
        String mes = "${fMes.format(picked)[0].toUpperCase()}${fMes.format(picked).substring(1)}";
        String dia = fDia.format(picked);
        String ano = fAno.format(picked);
        _fechaNacimiento = fFecha.format(picked);
        _fechaNacimientoController.text = "$dia de $mes de $ano";
        _fechaNacimientoValido = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Cancelar registro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(17),
          )
        ),
        content: Text(
          "¿Realmente desea cancelar el registro de usuario?",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(13),
          )
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            isDefaultAction: true,
            child: Text(
              'No',
              style: TextStyle(
                color: HexColor("#007AFF"),
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);

              var navigator = Navigator.of(context);
              var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
              navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
              navigator.pushReplacementNamed("login");
            },
            isDefaultAction: true,
            child: Text(
              'Si',
              style: TextStyle(
                color: HexColor("#007AFF"),
              ),
            ),
          ),
        ],
      )
    )) ?? false;
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
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(36),
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Datos Personales',
                    style: TextStyle(
                      color: HexColor("#202D39"),
                      fontFamily: 'SF Pro',
                      fontSize: ScreenUtil().setSp(30),
                      fontWeight: FontWeight.bold,
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
                  child: RadioField(
                    label: 'Sexo',
                    options: ["Masculino", "Femenino"],
                    onChange: (sexo) => setState(() { _sexo = sexo; }),
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
                    controller: _nombreController, 
                    valido: _nombreValido, 
                    error: _nombreError,
                    label: 'Nombre',
                    placeholder: 'Escribe tu nombre completo',
                    obscureText: false,
                    showSuffixIcon: false,
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
                    controller: _apellidoPaternoController, 
                    valido: _apellidoPaternoValido, 
                    error: _apellidoPaternoError,
                    label: 'Apellido Paterno',
                    placeholder: 'Escribe tu apellido paterno',
                    obscureText: false,
                    showSuffixIcon: false,
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
                    controller: _apellidoMaternoController, 
                    valido: _apellidoMaternoValido, 
                    error: _apellidoMaternoError,
                    label: 'Apellido Materno',
                    placeholder: 'Escribe tu apellido materno',
                    obscureText: false,
                    showSuffixIcon: false,
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
                  child: DateField(
                    controller: _fechaNacimientoController, 
                    label: 'Fecha Nacimiento',
                    placeholder: 'Fecha Nacimiento', 
                    onTap: (context) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDateFechaNacimiento(context);
                    },
                  ),
                ),

                Container(
                  height: ScreenUtil().setHeight(60),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                    top: ScreenUtil().setHeight(62),
                  ),
                  decoration: _nombreValido && _apellidoPaternoValido && _fechaNacimientoValido && !running ? BoxDecoration(
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
                    onPressed: _nombreValido && _apellidoPaternoValido && _fechaNacimientoValido && !running ? () async {
                      FocusScope.of(context).unfocus();

                      nuevoUsuario.nombre = _nombreController.text;
                      nuevoUsuario.apellidoPaterno = _apellidoPaternoController.text;
                      nuevoUsuario.apellidoMaterno = _apellidoMaternoController.text;
                      nuevoUsuario.fechaNacimiento = _fechaNacimiento;
                      nuevoUsuario.sexo = _sexo;

                      try {
                        bool creado = await ApiService.registrarNuevoUsuario(nuevoUsuario);
                        if( creado ) {
                          Navigator.pushReplacementNamed(context, 'foto_perfil');
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
                                // icon: MdiIcons.alertCircleOutline,
                                icon: 'assets/images/Error_Icon.png',
                                iconColor: HexColor("#FA5858"),
                                title: 'Crear usuario',
                                message: "Ha ocurrido un error al intentar crear el usuario.",
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

                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) => CupertinoAlertDialog(
                          //     title: Text(
                          //       'Error',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: ScreenUtil().setSp(17),
                          //       )
                          //     ),
                          //     content: Text(
                          //       "No se pudo crear el usuario.",
                          //       style: TextStyle(
                          //         fontSize: ScreenUtil().setSp(13),
                          //       )
                          //     ),
                          //     actions: <Widget>[
                          //       CupertinoDialogAction(
                          //         onPressed: () {
                          //           Navigator.of(context).pop();
                                    
                          //           var navigator = Navigator.of(context);
                          //           var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
                          //           navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
                          //           navigator.pushReplacementNamed("login");
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
                        }
                      } catch (e) {
                        // print(e);
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
                        gradient: _nombreValido && _apellidoPaternoValido && _fechaNacimientoValido && !running ? LinearGradient(
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
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(height: 50),

              ]
            ),
          )
        ),
      ),
    );
  }
}