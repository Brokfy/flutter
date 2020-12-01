import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectorMultiple extends StatefulWidget {
  final ValueChanged<List<Map>> onChanged;
  final ValueChanged<List<Map>> onInit;
  final List<Map> initialSelection;
  final List<Map> elements;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool enabled;
  final TextOverflow textOverflow;

  SelectorMultiple({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.elements,
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectorMultipleState(elements, initialSelection);
  }
}

class SelectorMultipleState extends State<SelectorMultiple> {
  List<Map> selectedItem = [];
  List<Map> elements = [];

  SelectorMultipleState(this.elements, this.selectedItem);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    Widget _widget;

    _widget = Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
        ),
        height: ScreenUtil().setHeight(84),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: elements.length, itemBuilder: (context, index) {
            var color;
            if( selectedItem != null && selectedItem.length > 0 ) {
              if ( selectedItem?.firstWhere((e) => e["id"] == elements[index]["id"]) != null ) {
                color = Color(0xFFFF0000);
              }
            }

            return Container(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(14), 
                horizontal: ScreenUtil().setWidth(12)
              ),
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(10),
              ),
              decoration: BoxDecoration(
                color: color,
                border: Border.all( 
                  color: const Color(0xFFB3B3B3).withOpacity(0.5), 
                  width: ScreenUtil().setSp(0.9), 
                  style: BorderStyle.solid
                ),
                borderRadius: BorderRadius.all( 
                  Radius.circular(50), 
                ), 
              ),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ScreenUtil.screenWidth * 0.6,
                    ),
                    child: Text(
                      elements[index]["etiqueta"],
                      style: TextStyle(
                        fontFamily: 'SF Pro',
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0079DE),
                      )
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      );

    return _widget;
  }

  @override
  void didUpdateWidget(SelectorMultiple oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
        if (widget.initialSelection != null) {
          selectedItem = widget.initialSelection;
        _onInit(elements);
      }
    }

    if (oldWidget.elements != widget.elements) {
        if (widget.elements != null) {
          elements = widget.elements;
        _onInit(elements);
      }
    }
  }

  void _publishSelection(List<Map> e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

  void _onInit(List<Map> e) {
    if (widget.onInit != null) {
      widget.onInit(e);
    }
  }
}
