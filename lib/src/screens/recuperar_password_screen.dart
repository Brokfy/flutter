import 'package:brokfy_app/src/models/verificar_numero_response.dart';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import '../widgets/country_code_picker/country_code_picker.dart';
import '../widgets/country_code_picker/country_code.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/image_from_assets.dart';
import 'package:brokfy_app/src/widgets/input_field.dart';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  @override
  _RecuperarPasswordScreenState createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  TextEditingController _phoneController;
  bool _phoneValido;
  bool _phoneError;
  MaskTextInputFormatter maskFormatter;
  bool running;
  CountryCode countryCode;

  @override
  void initState() {
    super.initState();
    _phoneController = new TextEditingController();
    _phoneValido = false;
    _phoneError = false;
    running = false;

    _phoneController.addListener(_validatePhoneNumber);
    maskFormatter = new MaskTextInputFormatter(mask: '(##) #### ## ##', filter: { "#": RegExp(r'[0-9]') });

    countryCode = CountryCode(code: "MX", flagUri: "assets/images/flags/MX.png", dialCode: "+52", name: "México");

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: HexColor("#F9FAFA"),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: HexColor("#F9FAFA"),
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  _validatePhoneNumber() {
    setState(() {
      // _phoneValido = maskFormatter.getUnmaskedText().length == 10;
      // _phoneError = maskFormatter.getUnmaskedText().length == 10 ? false : true;

      _phoneValido = _phoneController.text.length >= 9;
      _phoneError = !_phoneValido;
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
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(41),
                ),
                child: ImageFromAssets( assetName: 'recuperar', width: ScreenUtil().setWidth(170) ),
              ),

              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(40),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recuperar Contraseña',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(30),
                    color: HexColor("#202D39"),
                    fontFamily: 'SF Pro'
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(20),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Por favor, ingresa tu número de teléfono para crear una nueva contraseña.',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: HexColor("#5A666F"),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro'
                  ),
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
                height: ScreenUtil().setHeight(60),
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(41),
                  top: ScreenUtil().setHeight(62),
                ),
                decoration: _phoneValido && !running ? BoxDecoration(
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
                  onPressed: _phoneValido && !running ? () async {
                    FocusScope.of(context).unfocus();
                    // Navigator.pushNamed(context, 'codigo_recuperacion');

                    try {
                      nuevoUsuario.limpiarUsuario();
                      // String telefono = maskFormatter.getUnmaskedText();
                      nuevoUsuario.telefono = _phoneController.text;
                      nuevoUsuario.pais = countryCode.dialCode;

                      setState(() {
                        running = true;
                      });

                      VerificarNumeroResponse respuesta = await ApiService.recuperarPassword('${nuevoUsuario.pais.replaceAll("+", "")}${nuevoUsuario.telefono}');

                      setState(() {
                        running = false;
                      });

                      if( respuesta.status.toString() == "0" ) {
                          nuevoUsuario.idVerificacionNumero = respuesta.id.toString();
                          Navigator.pushNamed(context, 'codigo_recuperacion');
                          return;
                      }
                    } catch (e) {}

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
                          icon: 'assets/images/Error_Icon.png',
                          iconColor: HexColor("#333333"),
                          title: "Ha ocurrido un error",
                          message: "Por favor ingresa el número telefónico con el que te registraste.",
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
                      gradient: _phoneValido && !running ? LinearGradient(
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
                        "Enviar",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(15), 
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro'
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
    );
  }
}
