import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AjustesScreen extends StatefulWidget {
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  PreferencesService _pref;

  @override
  void initState() {
    super.initState();
    _pref = PreferencesService();
    getAuth();
  }

  void logout(BuildContext context) async {
    _pref.isLogged = false;
    // await DBService.db.deleteAllAuth();
    Navigator.of(context).pushReplacementNamed('login');
  }

  void getAuth() async {
    var temp = await DBService.db.getAuthFirst();
    print(temp.nameAws);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: ScreenUtil.screenHeight * 0.1),
          child: RaisedButton(
            onPressed: () {
              logout(context);
            },
            child: Text(
              'Cerrar Sesión'
            ),
          ),
        )
      ),
    );
  }
}