import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TemplateScreen extends StatefulWidget {
  @override
  _TemplateScreenState createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {

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
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F9FAFA"),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: HexColor("#202D39"),
          ),
          backgroundColor: HexColor("#F9FAFA"),
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(), 
            child: Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(flex: 8, child: Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      
                    ],
                  )
                )),
                Expanded(flex: 1, child: Container()),
              ]
            )
          ),
        )
      ),
    );
  }
}