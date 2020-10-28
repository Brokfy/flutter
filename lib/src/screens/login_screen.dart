import 'package:brokfy_app/src/models/auth_api_response.dart';
import 'package:brokfy_app/src/services/db_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/loading.dart';
import 'package:brokfy_app/src/widgets/logged_in_previously.dart';
import 'package:brokfy_app/src/widgets/login_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthApiResponse _userInfo;
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = true;

    DBService.db.getAuthFirst().then((value) {
      setState(() {
        _userInfo = value;
        loading = false;
      });
    });
  }

  Widget _contenidoPantalla() {
    // print(_userInfo);
    if ( _userInfo != null && (_userInfo.username != null || _userInfo.username != "") ) {
      return LoggedInPreviously(
        userInfo: this._userInfo
      );
    }
    return LoginForm();
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
    
    if( loading ) {
      return SafeArea(
        child: Scaffold(
          body: Loading(),
        )
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F9FAFA"),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(), 
          child: _contenidoPantalla(),
        )
      ),
    );
  }
}

