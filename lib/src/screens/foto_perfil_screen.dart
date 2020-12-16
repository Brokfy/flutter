import 'dart:io';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/screens/login_screen.dart';
import 'package:brokfy_app/src/services/api_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/procesando.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FotoPerfilScreen extends StatefulWidget {
  @override
  _FotoPerfilScreenState createState() => _FotoPerfilScreenState();
}

class _FotoPerfilScreenState extends State<FotoPerfilScreen> {
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  bool running = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _pickImage(ImageSource source) async {
    try {
      var pickedFile = await _picker.getImage(source: source, maxWidth: 500);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {}
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Container(
          height: ScreenUtil().setHeight(160),
          width: ScreenUtil().setHeight(160),
          margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(121),
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: FileImage(File(_imageFile.path)))),
        ),
      );
    } else {
      return Center(
        child: Container(
          alignment: Alignment.center,
          height: ScreenUtil().setHeight(160),
          width: ScreenUtil().setWidth(160),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(121),
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(41),
          ),
          child: Container(
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setHeight(87),
              child: Image.asset('assets/images/shield.png')),
        ),
      );
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
    final nuevoUsuario = Provider.of<NuevoUsuario>(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor("#F9FAFA"),
          // appBar: AppBar(
          //   iconTheme: IconThemeData(
          //     color: HexColor("#202D39"),
          //   ),
          //   backgroundColor: HexColor("#F9FAFA"),
          //   bottomOpacity: 0.0,
          //   elevation: 0.0,
          // ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(36),
                    left: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(41),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Foto de Perfil',
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
                      'Añade una foto de perfil de Brokfy añadiendo desde la cámara o tu galería de fotos.',
                      style: TextStyle(
                          fontFamily: 'SF Pro',
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.w400)),
                ),

                _previewImage(),

                // Container(
                //   alignment: Alignment.center,
                //   margin: EdgeInsets.only(
                //     top: ScreenUtil().setHeight(36),
                //     left: ScreenUtil().setWidth(40),
                //     right: ScreenUtil().setWidth(41),
                //   ),
                //   child: RichText(
                //     text: TextSpan(
                //       text: 'Cambiar foto de perfil',
                //       style: TextStyle(
                //         color: HexColor("#0079DE"),
                //         fontFamily: 'Quicksand',
                //         fontWeight: FontWeight.bold,
                //         fontSize: ScreenUtil().setSp(15),
                //       ),
                //       recognizer: TapGestureRecognizer()
                //         ..onTap = ,
                //     ),
                //   ),
                // ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(36),
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(41),
                    ),
                    height: ScreenUtil().setHeight(70),
                    width: ScreenUtil().setWidth(220),
                    child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        // var navigator = Navigator.of(context);
                        // var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
                        // navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
                        // navigator.pushReplacementNamed("login");

                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                color: Color(0xFF737373),
                                height: ScreenUtil().setHeight(376),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ListView(
                                    children: [
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(30),
                                            ),
                                            Text(
                                              'Seleccionar foto de perfíl',
                                              style: TextStyle(
                                                  color: Color(0xFF8F8F8F),
                                                  fontFamily: 'SF Pro',
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(21),
                                            ),
                                            Container(
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(41),
                                                right:
                                                    ScreenUtil().setWidth(41),
                                                top: ScreenUtil().setHeight(10),
                                              ),
                                              decoration: running
                                                  ? null
                                                  : BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: HexColor(
                                                                  "#0079DE")
                                                              .withOpacity(0.5),
                                                          spreadRadius: 0,
                                                          blurRadius:
                                                              ScreenUtil()
                                                                  .setHeight(9),
                                                          offset: Offset(
                                                              0,
                                                              ScreenUtil()
                                                                  .setHeight(
                                                                      3)), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                              child: RaisedButton(
                                                onPressed: running
                                                    ? null
                                                    : () async {
                                                        Navigator.of(context)
                                                            .pop('Camara');
                                                        _pickImage(
                                                            ImageSource.camera);
                                                      },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                splashColor: Color.fromRGBO(
                                                    255, 255, 255, 0.2),
                                                disabledColor:
                                                    HexColor("#C4C4C4"),
                                                textColor: Colors.white,
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: running
                                                      ? null
                                                      : BoxDecoration(
                                                          color: HexColor(
                                                              "#C4C4C4"),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              HexColor(
                                                                  "#1F92F3"),
                                                              HexColor(
                                                                  "#0079DE")
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0)),
                                                  child: Container(
                                                    // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: running
                                                        ? Procesando()
                                                        : Text(
                                                            "Cámara",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height:
                                                  ScreenUtil().setHeight(60),
                                              margin: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(41),
                                                right:
                                                    ScreenUtil().setWidth(41),
                                                top: ScreenUtil().setHeight(25),
                                              ),
                                              decoration: running
                                                  ? null
                                                  : BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: HexColor(
                                                                  "#0079DE")
                                                              .withOpacity(0.5),
                                                          spreadRadius: 0,
                                                          blurRadius:
                                                              ScreenUtil()
                                                                  .setHeight(9),
                                                          offset: Offset(
                                                              0,
                                                              ScreenUtil()
                                                                  .setHeight(
                                                                      3)), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                              child: RaisedButton(
                                                onPressed: running
                                                    ? null
                                                    : () async {
                                                        Navigator.of(context)
                                                            .pop('Galeria');
                                                        _pickImage(ImageSource
                                                            .gallery);
                                                      },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                splashColor: Color.fromRGBO(
                                                    255, 255, 255, 0.2),
                                                disabledColor:
                                                    HexColor("#C4C4C4"),
                                                textColor: Colors.white,
                                                disabledTextColor: Colors.white,
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: running
                                                      ? null
                                                      : BoxDecoration(
                                                          color: HexColor(
                                                              "#C4C4C4"),
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              HexColor(
                                                                  "#1F92F3"),
                                                              HexColor(
                                                                  "#0079DE")
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0)),
                                                  child: Container(
                                                    // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: running
                                                        ? Procesando()
                                                        : Text(
                                                            "Galería de Fotos",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(30),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).canvasColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              topRight: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              bottomLeft: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              bottomRight: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                            )),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(10),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: ScreenUtil()
                                                      .setHeight(33),
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: 'Cancelar',
                                                    style: TextStyle(
                                                      color:
                                                          HexColor("#0079DE"),
                                                      fontFamily: 'SF Pro',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: ScreenUtil()
                                                          .setSp(16),
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(30),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).canvasColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              topRight: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              bottomLeft: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                              bottomRight: Radius.circular(
                                                  ScreenUtil().setWidth(20)),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });

                        // final act = CupertinoActionSheet(
                        //   title: Text(
                        //     'Seleccionar foto de perfíl',
                        //     style: TextStyle(
                        //       color: Color(0xFF8F8F8F),
                        //       fontFamily: 'SF Pro',
                        //       fontSize: ScreenUtil().setSp(13),
                        //     ),
                        //   ),
                        //   actions: <Widget>[
                        //     CupertinoActionSheetAction(
                        //       child: Text('Cámara'),
                        //       onPressed: () {
                        //         Navigator.of(context).pop('Camara');
                        //         _pickImage(ImageSource.camera);
                        //       },
                        //     ),
                        //     CupertinoActionSheetAction(
                        //       child: Text('Galería'),
                        //       onPressed: () {
                        //         Navigator.of(context).pop('Galeria');
                        //         _pickImage(ImageSource.gallery);
                        //       },
                        //     ),
                        //   ],
                        //   cancelButton: CupertinoActionSheetAction(
                        //     isDestructiveAction: true,
                        //     child: Text(
                        //       'Cancelar',
                        //       style: TextStyle(
                        //         color: Color(0xFF007AFF),
                        //         fontFamily: 'SF Pro',
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: ScreenUtil().setSp(16),
                        //       ),
                        //     ),
                        //     onPressed: () => Navigator.of(context).pop(),
                        //   ),
                        // );

                        // showCupertinoModalPopup(
                        //   context: context,
                        //   builder: (BuildContext context) => act
                        // );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0079DE),
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "Cambiar foto de perfil",
                                style: TextStyle(
                                  color: Color(0xFF0079DE),
                                  fontFamily: 'SF Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                          ],
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
                    top: ScreenUtil().setHeight(130),
                  ),
                  decoration: running
                      ? null
                      : BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: HexColor("#0079DE").withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: ScreenUtil().setHeight(9),
                              offset: Offset(
                                  0,
                                  ScreenUtil().setHeight(
                                      3)), // changes position of shadow
                            ),
                          ],
                        ),
                  child: RaisedButton(
                    onPressed: running
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              running = true;
                            });

                            await ApiService.actualizarImagenPerfil(
                                nuevoUsuario.telefono, File(_imageFile.path));

                            setState(() {
                              running = false;
                            });

                            await Future.delayed(Duration(milliseconds: 50));

                            var navigator = Navigator.of(context);
                            var route = MaterialPageRoute(
                                builder: ((BuildContext context) =>
                                    LoginScreen()));
                            navigator.pushAndRemoveUntil(
                                route, (Route<dynamic> route) => route.isFirst);
                            navigator.pushReplacementNamed("login");
                          },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                    disabledColor: HexColor("#C4C4C4"),
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: running
                          ? null
                          : BoxDecoration(
                              color: HexColor("#C4C4C4"),
                              gradient: LinearGradient(
                                colors: [
                                  HexColor("#1F92F3"),
                                  HexColor("#0079DE")
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(5.0)),
                      child: Container(
                        // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: running
                            ? Procesando()
                            : Text(
                                "Continuar",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(33),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Omitir',
                        style: TextStyle(
                          color: HexColor("#0079DE"),
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            FocusScope.of(context).unfocus();

                            var navigator = Navigator.of(context);
                            var route = MaterialPageRoute(
                                builder: ((BuildContext context) =>
                                    LoginScreen()));
                            navigator.pushAndRemoveUntil(
                                route, (Route<dynamic> route) => route.isFirst);
                            navigator.pushReplacementNamed("login");
                          },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // child: Row(
            //   children: [
            //     Expanded(flex: 1, child: Container()),
            //     Expanded(flex: 8, child: Container(
            //       padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            //       height: MediaQuery.of(context).size.height,
            //       child: Column(
            //         children: [
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             child: Text(
            //               'Foto de Perfil',
            //               style: TextStyle(
            //                 fontSize: ScreenUtil().setSp(30),
            //                 fontWeight: FontWeight.bold,
            //                 color: HexColor("#202D39")
            //               )
            //             ),
            //           ),

            //           Container(
            //             alignment: Alignment.centerLeft,
            //             margin: EdgeInsets.only(
            //               top: ScreenUtil().setHeight(20),
            //             ),
            //             child: Text(
            //               'Añade una foto de perfil de Brokfy añadiendo desde la cámara o tu galería de fotos.',
            //               style: TextStyle(
            //                 fontSize: ScreenUtil().setSp(15),
            //                 fontWeight: FontWeight.w400
            //               )
            //             ),
            //           ),

            //           Container(
            //             height: ScreenUtil().setHeight(160),
            //             width: ScreenUtil().setWidth(160),
            //             margin: EdgeInsets.only(
            //               top: ScreenUtil().setHeight(121),
            //             ),
            //             child: Placeholder(),
            //           ),

            //           Container(
            //             margin: EdgeInsets.only(
            //               top: ScreenUtil().setHeight(36),
            //             ),
            //             child: RichText(
            //               text: TextSpan(
            //                 text: 'Cambiar foto  de perfil',
            //                 style: TextStyle(
            //                   color: HexColor("#0079DE"),
            //                   fontFamily: 'Quicksand',
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: ScreenUtil().setSp(15),
            //                 ),
            //                 recognizer: TapGestureRecognizer()
            //                     ..onTap = () {
            //                       FocusScope.of(context).unfocus();
            //                       var navigator = Navigator.of(context);
            //                       var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
            //                       navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
            //                       navigator.pushReplacementNamed("login");
            //                     },
            //               ),
            //             ),
            //           ),

            //           Container(
            //             height: ScreenUtil().setHeight(48),
            //             margin: EdgeInsets.only(
            //               top: ScreenUtil().setHeight(168),
            //             ),
            //             decoration: BoxDecoration(
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: HexColor("#0079DE").withOpacity(0.5),
            //                   spreadRadius: 0,
            //                   blurRadius: ScreenUtil().setHeight(9),
            //                   offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            //                 ),
            //               ],
            //             ),
            //             child: RaisedButton(
            //               onPressed: () {
            //                 FocusScope.of(context).unfocus();
            //                 var navigator = Navigator.of(context);
            //                 var route = MaterialPageRoute(builder: ((BuildContext context) => LoginScreen()));
            //                 navigator.pushAndRemoveUntil(route, (Route<dynamic> route) => route.isFirst);
            //                 navigator.pushReplacementNamed("login");
            //               },
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //               splashColor: Color.fromRGBO(255, 255, 255, 0.2),
            //               disabledColor: HexColor("#C4C4C4"),
            //               textColor: Colors.white,
            //               disabledTextColor: Colors.white,
            //               padding: EdgeInsets.all(0.0),
            //               child: Ink(
            //                 decoration: BoxDecoration(
            //                   color: HexColor("#C4C4C4"),
            //                   gradient: LinearGradient(
            //                     colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
            //                     begin: Alignment.topCenter,
            //                     end: Alignment.bottomCenter,
            //                   ),
            //                   borderRadius: BorderRadius.circular(5.0)
            //                 ),
            //                 child: Container(
            //                   constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            //                   alignment: Alignment.center,
            //                   child: Text(
            //                     "CONTINUAR",
            //                     style: TextStyle(
            //                       fontSize: ScreenUtil().setSp(15),
            //                       fontWeight: FontWeight.bold
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),

            //           Container(
            //             margin: EdgeInsets.only(
            //               top: ScreenUtil().setHeight(33),
            //             ),
            //             child: RichText(
            //               text: TextSpan(
            //                 text: 'OMITIR',
            //                 style: TextStyle(
            //                   color: HexColor("#0079DE"),
            //                   fontFamily: 'Quicksand',
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: ScreenUtil().setSp(15),
            //                 ),
            //                 recognizer: TapGestureRecognizer()
            //                     ..onTap = () {
            //                       FocusScope.of(context).unfocus();
            //                       Navigator.pushNamed(context, 'recuperar');
            //                     },
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     )),
            //     Expanded(flex: 1, child: Container()),
            //   ]
            // )
          )),
    );
  }
}
