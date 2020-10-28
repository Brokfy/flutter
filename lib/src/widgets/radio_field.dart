import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'hex_color.dart';

class RadioField extends StatelessWidget {
  const RadioField({
    Key key,
    @required List<String> options,
    @required String label,
    @required Function onChange,
  }) : _options = options, _label = label, _onChange = onChange, super(key: key);

  final List<String> _options;
  final String _label;
  final Function _onChange;

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
            alignment: Alignment.centerLeft,
            child: Text(
              this._label,
              style: TextStyle(
                color: HexColor("#5A666F"),
                fontFamily: 'SF Pro',
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(8),
            ),
            color: Colors.transparent,
            height: ScreenUtil().setHeight(52),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(5)),
              height: ScreenUtil().setHeight(100),
              decoration: BoxDecoration(
                color: HexColor("#E8E9EA"),
                borderRadius: BorderRadius.circular(50),
              ),
              child: DefaultTabController(
                length: this._options.length,
                child: TabBar(
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: ScreenUtil().setSp(14),
                    fontWeight: FontWeight.bold
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: HexColor("#C9CACB"),
                        spreadRadius: 0,
                        blurRadius: ScreenUtil().setHeight(4),
                        offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
                      ),
                    ],
                  ),
                  tabs: this._options.map((e) => Tab(text: e,)).toList(),
                  onTap: (index) => this._onChange(this._options[index]),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}