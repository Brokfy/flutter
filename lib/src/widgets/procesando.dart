import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class Procesando extends StatelessWidget {

  const Procesando({
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1, 
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white54),
            )
          ),
          SizedBox(width: 12.0,),
          Text(
            "Procesando...",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15), 
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Pro', 
            ),
          ),
        ],
      ),
    );
  }
}