import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'hex_color.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    this.maskFormatter,
    this.showSuffixIcon = false,
    @required TextEditingController controller,
    @required bool valido,
    @required bool error,
    @required String label,
    @required String placeholder,
    @required TextInputType keyboardType,
    @required bool obscureText
  }) : _controller = controller, _valido = valido, _error = error, _label = label, _placeholder = placeholder, _keyboardType = keyboardType, _obscureText = obscureText, super(key: key);

  final MaskTextInputFormatter maskFormatter;
  final TextEditingController _controller;
  final bool _valido;
  final bool _error;
  final String _label;
  final String _placeholder;
  final TextInputType _keyboardType;
  final bool _obscureText;
  final bool showSuffixIcon;

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
              child: TextField(
                keyboardType: _keyboardType,
                inputFormatters: maskFormatter != null ? [maskFormatter] : null,
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
                  isDense: true, 
                  suffixIcon: showSuffixIcon == true ? Container(
                    width: 0,
                    alignment: Alignment(0.99, -0.3),
                    child: _valido ? Icon(
                        Icons.check_circle, 
                        color: HexColor("#0079DE"),
                        size: ScreenUtil.screenWidth/310.0 * 18,
                      ) :
                      Container(),
                  ) : null,
                  enabledBorder: UnderlineInputBorder(      
                    borderSide: BorderSide(
                      width: ScreenUtil.screenWidth/310.0 * 1.2,
                      color: _valido ? HexColor("#0079DE") :
                        _error ? HexColor("#FF0000") :
                        HexColor("#4F5351").withOpacity(0.2)
                    ),
                  ), 
                  hintText: _placeholder,
                  hintStyle: TextStyle(
                    color: HexColor("#CCCCCC"),
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(18),
                    fontFamily: 'SF Pro', 
                  ),
                ),
                style: TextStyle(
                  color: HexColor("#202D39"),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(18),
                  fontFamily: 'SF Pro', 
                  letterSpacing:  maskFormatter != null ? -0.8 : null,
                ),
                obscureText: _obscureText
              ),
            ),
          ),
        ],
      ),
    );
  }
}