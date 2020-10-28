import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'hex_color.dart';


class BotonSOS extends StatelessWidget {
  final String brokfyPhone = '5555555555';

  const BotonSOS({
    Key key,
  }) : super(key: key);

  void _callBrokfy() async {
    String url = 'tel:${this.brokfyPhone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    
    return Container(
      alignment: Alignment.centerRight,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: ScreenUtil().setWidth(58),
          height: ScreenUtil().setHeight(58),
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp
            ),
            boxShadow: [
              BoxShadow(
                color: HexColor("#0079DE").withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: new RawMaterialButton(
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Text(
              'SOS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HexColor("#FFFFFF"),
                fontSize: ScreenUtil().setSp(18)
              ),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();

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
                            child: Image.asset('assets/images/sos.png', width: ScreenUtil().setWidth(212)),
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
                                  'Llamada de Emergencia',
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
                                  'Te ayudaremos con las pólizas que tienes dadas de alta con nosotros',
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
                              onPressed: () => _callBrokfy(),
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
                                    "Llamar a Brokfy",
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

              // showGeneralDialog(
              //   context: context,
              //   barrierDismissible: false,
              //   barrierLabel: MaterialLocalizations.of(context)
              //       .modalBarrierDismissLabel,
              //   barrierColor: HexColor("#0079DE").withOpacity(0.9),
              //   transitionDuration: const Duration(milliseconds: 200),
              //   pageBuilder: (BuildContext buildContext,
              //       Animation animation,
              //       Animation secondaryAnimation) {
              //       SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              //         statusBarColor: HexColor("#1486E1"),
              //         statusBarIconBrightness: Brightness.light,
              //         statusBarBrightness: Brightness.light,
              //         systemNavigationBarColor: HexColor("#1486E1"),
              //         systemNavigationBarDividerColor: Colors.grey,
              //         systemNavigationBarIconBrightness: Brightness.light,
              //       ));

              //     return Center(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(14.0)
              //         ),
              //         margin: EdgeInsets.symmetric(
              //           vertical: ScreenUtil.screenHeight * 0.143,
              //           horizontal: ScreenUtil.screenWidth * 0.08
              //         ),
              //         width: ScreenUtil.screenWidth * 0.8,
              //         padding: EdgeInsets.all(20),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Container(
              //               height: ScreenUtil.screenHeight * 0.1,
              //               margin: EdgeInsets.only(
              //                 bottom: ScreenUtil.screenHeight * 0.02
              //               ),
              //               child: Image.asset('assets/images/brokfy_azul.png', width: ScreenUtil().setWidth(192)),
              //             ),

              //             Expanded(
              //               child: Image.asset('assets/images/sos.png', width: ScreenUtil().setWidth(210)),
              //             ),

              //             SizedBox(height: ScreenUtil().setHeight(20),),
              //             Material(
              //               type: MaterialType.transparency,
              //               child: Container(
              //                 height: ScreenUtil().setHeight(46),
              //                 width: double.infinity,
              //                 // color: Colors.red,
              //                 child: Center(
              //                   child: Text(
              //                     'Llamada de Emergencia',
              //                     style: TextStyle(
              //                       fontSize: ScreenUtil().setSp(17), 
              //                       color: HexColor("#202D39"), 
              //                       fontWeight: FontWeight.bold
              //                     )
              //                   ),
              //                 ),
              //               ),
              //             ),

              //             SizedBox(height: ScreenUtil().setHeight(10),),
              //             Material(
              //               type: MaterialType.transparency,
              //               child: Container(
              //                 alignment: Alignment.center,
              //                 width: double.infinity,
              //                 child: Center(
              //                   child: Text(
              //                     'Al presionar el boton de llamar a Brokfy, se enlazará una llamada para obtener ayuda.',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       fontSize: ScreenUtil().setSp(14),
              //                       color: HexColor("#202D39")
              //                     ),
              //                     overflow: TextOverflow.ellipsis,
              //                     maxLines: 2,
              //                   ),
              //                 ),
              //               ),
              //             ),

              //             SizedBox(height: ScreenUtil().setHeight(40),),
              //             Container(
              //               height: ScreenUtil().setHeight(60),
              //               child: RaisedButton(
              //                 onPressed: () => _callBrokfy(),
              //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              //                 splashColor: Color.fromRGBO(255, 255, 255, 0.2),
              //                 disabledColor: HexColor("#C4C4C4"),
              //                 textColor: Colors.white,
              //                 disabledTextColor: Colors.white,
              //                 padding: EdgeInsets.all(0.0),
              //                 child: Ink(
              //                   decoration: BoxDecoration(
              //                     color: HexColor("#C4C4C4"),
              //                     gradient: LinearGradient(
              //                       colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
              //                       begin: Alignment.topCenter,
              //                       end: Alignment.bottomCenter,
              //                     ),
              //                     borderRadius: BorderRadius.circular(5.0)
              //                   ),
              //                   child: Container(
              //                     // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              //                     width: ScreenUtil().setWidth(312),
              //                     alignment: Alignment.center,
              //                     child: Text(
              //                       "LLAMAR A BROKFY",
              //                       style: TextStyle(
              //                         fontSize: ScreenUtil().setSp(15), 
              //                         fontWeight: FontWeight.bold
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),

              //             SizedBox(height: ScreenUtil().setHeight(15),),
              //             Container(
              //               width: ScreenUtil().setWidth(350),
              //               height: ScreenUtil().setHeight(44),
              //               alignment: Alignment.center,
              //               child: RichText(
              //                 text: TextSpan(
              //                   text: 'Cerrar',
              //                   style: TextStyle(
              //                     color: HexColor("#0079DE"), 
              //                     fontSize: ScreenUtil().setSp(15),
              //                     fontFamily: 'Quicksand', 
              //                     fontWeight: FontWeight.bold
              //                   ),
              //                   recognizer: TapGestureRecognizer()..onTap = () {
              //                     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              //                       statusBarColor: HexColor("#F9FAFA"),
              //                       statusBarIconBrightness: Brightness.dark,
              //                       statusBarBrightness: Brightness.light,
              //                       systemNavigationBarColor: HexColor("#F9FAFA"),
              //                       systemNavigationBarDividerColor: Colors.grey,
              //                       systemNavigationBarIconBrightness: Brightness.dark,
              //                     ));
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   }
              // );
            },
          ),
        ),
      ),
    );
  }
}