import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'hex_color.dart';

class DateField extends StatelessWidget {
  const DateField({
    Key key,
    @required TextEditingController controller,
    @required String label,
    @required String placeholder,
    @required Function onTap,
  })  : _controller = controller,
        _label = label,
        _placeholder = placeholder,
        _onTap = onTap,
        super(key: key);

  final TextEditingController _controller;
  final String _label;
  final String _placeholder;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    // print('Device width:${ScreenUtil.screenWidth}'); //Device width
    // print('Device height:${ScreenUtil.screenHeight}'); //Device height

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ScreenUtil().setHeight(26),
            alignment: Alignment.centerLeft,
            child: Text(
              _label,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: ScreenUtil().setSp(14),
                color: HexColor("#5A666F"),
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(55),
            alignment: Alignment.centerLeft,
            child: Container(
              height: double.infinity,
              child: GestureDetector(
                onTap: () => _onTap(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: this._placeholder,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10)),
                      isDense: true,
                      suffixIcon: Container(
                        width: 0,
                        alignment: Alignment(0.99, -0.3),
                        child: Image.asset('assets/images/Calendar_icon.png',
                            filterQuality: FilterQuality.high,
                            width: 30,
                            height: 30),
                        // Icon(
                        //   MdiIcons.calendar,
                        //   color: HexColor("#BEC4C7"),
                        //   size: ScreenUtil().setSp(28),
                        // ),
                      ),
                      hintStyle: TextStyle(
                        color: HexColor("#CCCCCC"),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    ),
                    style: TextStyle(
                      color: HexColor("#202D39"),
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(18),
                    ),
                    onTap: () => _onTap(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
