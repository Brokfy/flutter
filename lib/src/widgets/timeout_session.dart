import 'dart:async';
import 'package:brokfy_app/src/widgets/message_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import '../../src/services/preferences_service.dart';

class TimeoutSession extends StatefulWidget {
  final Widget child; 
  final Duration duration;

  const TimeoutSession({
    Key key,
    @required this.child,
    @required this.duration,
  }) : super(key: key);

  @override
  TimeoutSessionState createState() => TimeoutSessionState();
}

class TimeoutSessionState extends State<TimeoutSession> {
  Timer timer;
  final _prefs = new PreferencesService();

  @override
  void initState() {
    super.initState();
    
    this.timer = Timer(widget.duration, () {
      timeOutCallBack(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    this.timer.cancel();
  }

  void cancelTimer() {
    if( _prefs.isLogged ) {
      if (this.timer != null) {
        this.timer.cancel();
      }
    }
  }

  void restartTimer() {
    if( _prefs.isLogged ) {
      if (this.timer != null) {
        this.timer.cancel();
      }
      this.timer = Timer(widget.duration, () {
        timeOutCallBack(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      behavior: HitTestBehavior.translucent,
      onTapDown: (tapDown) => restartTimer(),
    );
  }

void timeOutCallBack(BuildContext context) async {
    _prefs.isLogged = false;
    // await DBService.db.deleteAllAuth();
    this.timer.cancel();
    setState(() {});
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: HexColor("#B2B2B2").withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            return Future.value(true);
          },
          child: MessageInfo(
            // icon: MdiIcons.clockAlertOutline,
            icon: 'assets/images/Verified_Icon.png',
            title: 'Tiempo de sesión expirado',
            message: 'Por seguridad hemos finalizado tu sesión por inactividad',
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            },
          ),
        );
      }
    );
  }
}