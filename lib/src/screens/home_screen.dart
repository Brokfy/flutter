import 'package:brokfy_app/src/screens/ajustes_screen.dart';
import 'package:brokfy_app/src/screens/ofertas_screen.dart';
import 'package:brokfy_app/src/screens/polizas_screen.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    // double width = MediaQuery.of(context).size.width;
    // double heigh = MediaQuery.of(context).size.height;

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
        body: IndexedStack(
          index: _currentIndex,
          children: [
            PolizasScreen(),
            OfertasScreen(),
            AjustesScreen(),
          ].toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              // icon: Image.asset('assets/images/navbar_polizas.png', width: ScreenUtil().setWidth(32)),
              icon: Icon(MdiIcons.folderOutline),
              backgroundColor: HexColor("#F9FAFA"),
               title: Container(
                child: Text(
                  'Pólizas',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.w500,
                    color: _currentIndex == 0 ? HexColor("#6097EF") : HexColor("#999999"),
                  ),
                ),
              ),
            ),

            BottomNavigationBarItem(
              // icon: Image.asset('assets/images/navbar_ofertas.png', width: ScreenUtil().setWidth(32)),
              icon: Icon(MdiIcons.tag),
              backgroundColor: Colors.transparent,
              title: Container(
                child: Text(
                  'Ofertas',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.w500,
                    color: _currentIndex == 1 ? HexColor("#6097EF") : HexColor("#999999"),
                  ),
                ),
              ),
            ),

            BottomNavigationBarItem(
              // icon: Image.asset('assets/images/navbar_ajustes.png', width: ScreenUtil().setWidth(32)),
              icon: Icon(MdiIcons.settingsOutline),
              backgroundColor: Colors.transparent,
              title: Container(
                child: Text(
                  'Ajustes',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.w500,
                    color: _currentIndex == 2 ? HexColor("#6097EF") : HexColor("#999999"),
                  ),
                ),
              ),
            ),
          ].toList(),
        ),
      ),
    );
  }
}