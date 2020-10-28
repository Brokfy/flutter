import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class MessageInfo extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final Function onTap;
  final Color iconColor;
  final String accion;
  final bool cerrarBtn;

  const MessageInfo({
    Key key, 
    @required this.icon, 
    @required this.title, 
    @required this.message, 
    @required this.onTap, 
    this.iconColor = const Color(0xFF057DE1),
    this.accion = '',
    this.cerrarBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            boxShadow: [
              BoxShadow(
                color: HexColor("#CDCDCD").withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
            vertical: size.height * 0.143,
            horizontal: size.width * 0.08
          ),
          width: size.width * 0.8,
          height: this.cerrarBtn ? 340 : 320,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 98,
                width: 76,
                child: Image.asset(this.icon)
              ),

              SizedBox(height: ScreenUtil().setHeight(13),),

              Text(
                this.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  inherit: true,
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro',
                  color: HexColor("#333333"),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(9),),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  this.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontFamily: 'SF Pro',
                    color: HexColor("#6B706E")
                  ),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(21),),

              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: this.onTap,
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
                        this.accion == '' ? "Aceptar" : this.accion,
                        style: TextStyle(
                          color: HexColor("#FFFFFF"),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro'
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              this.cerrarBtn ? SizedBox(height: ScreenUtil().setHeight(16),) : Container(),
              this.cerrarBtn ? Container(
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
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}