import 'dart:async';
import 'package:brokfy_app/src/providers/foto_usuario_provider.dart';
import 'package:brokfy_app/src/providers/admin_chat_provider.dart';
import 'package:brokfy_app/src/providers/nuevo_usuario.dart';
import 'package:brokfy_app/src/screens/chat_detail_page.dart';
import 'package:brokfy_app/src/screens/crear_password_screen.dart';
import 'package:brokfy_app/src/screens/crear_usuario_screen.dart';
import 'package:brokfy_app/src/screens/datos_personales_screen.dart';
import 'package:brokfy_app/src/screens/foto_perfil_screen.dart';
import 'package:brokfy_app/src/screens/home_screen.dart';
import 'package:brokfy_app/src/screens/recuperar_password_screen.dart';
import 'package:brokfy_app/src/screens/verificacion_screen.dart';
import 'package:brokfy_app/src/widgets/timeout_session.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'src/models/admin_model.dart';
import 'src/services/preferences_service.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/intro_screen.dart';
import 'src/screens/codigo_recuperacion_screen.dart';
import 'src/screens/chat_poliza_screen.dart';
import 'src/widgets/country_code_picker/country_localizations.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF1F92F3),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.grey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  final _prefs = new PreferencesService();
  await _prefs.initPrefs();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp( pref: _prefs, duration: Duration(minutes: 30),)));
}

class MyApp extends StatelessWidget {
  final PreferencesService pref; 
  final Timer timer;
  final Duration duration;

  const MyApp({
    Key key,
    @required this.pref,
    this.timer,
    this.duration
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NuevoUsuario>(create: (_) => NuevoUsuario()),
        ChangeNotifierProvider<FotoUsuarioProvider>(create: (_) => FotoUsuarioProvider()),
        ChangeNotifierProvider<AdminChatProvider>(create: (_) => AdminChatProvider()),
        ChangeNotifierProvider<AdminModel>(create: (_) => AdminModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(fontFamily: 'Quicksand'),
        supportedLocales: [
          Locale('es'),
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        initialRoute: this.pref.skippedIntro != true ? 'intro' :
          // this.pref.isLogged != true ? 'login' :
          'login',
        // initialRoute: 'crear_password',
        routes: {
          'login': ( BuildContext context ) => LoginScreen(),
          'intro': ( BuildContext context ) => IntroScreen(),
          'recuperar': ( BuildContext context ) => RecuperarPasswordScreen(),
          'codigo_recuperacion': ( BuildContext context ) => CodigoRecuperacionScreen(),
          'crear_password': ( BuildContext context ) => CrearPasswordScreen(),
          'crear_usuario': ( BuildContext context ) => CrearUsuarioScreen(),
          'datos_personales': ( BuildContext context ) => DatosPersonalesScreen(),
          'verificacion': ( BuildContext context ) => VerificacionScreen(),
          'foto_perfil': ( BuildContext context ) => FotoPerfilScreen(),
          'chat_poliza': ( BuildContext context ) => TimeoutSession(child: ChatPolizaScreen(), duration: duration,),
          'chat_detail': ( BuildContext context ) => TimeoutSession(child: ChatDetailPage(), duration: duration,),
          'home': ( BuildContext context ) => TimeoutSession(child: HomeScreen(), duration: duration,),
        },
      ),
    );
  }
}