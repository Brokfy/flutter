import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// selection dialog used for selection of the country code
class SelectOptionFromList extends StatefulWidget {
  final List<dynamic> elements;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle textStyle;
  final WidgetBuilder emptySearchBuilder;
  final Size size;
  final bool hideSearch;
  final String title;
  final String field;

  /// elements passed as favorite
  final List<dynamic> favoriteElements;

  SelectOptionFromList(
    this.elements,
    this.favoriteElements, {
    Key key,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.size,
    this.hideSearch = false,
    this.title,
    this.field
  })  : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration =
            searchDecoration.copyWith(prefixIcon: Icon(Icons.search)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectOptionFromListState();
}

class _SelectOptionFromListState extends State<SelectOptionFromList> {
  /// this is useful for filtering purpose
  List<dynamic> filteredElements;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.all(0.0),
              icon: Image.asset('assets/images/Back.png', filterQuality: FilterQuality.high,)
            ),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF202D39),
          ),
          backgroundColor: Color(0xFFFCFBFF),
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.title != null ? widget.title : "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w500,
              color: Color(0xFF202D39)
            )
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Divider(height: 8,),

            if (!widget.hideSearch)
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //   child: TextField(
              //     style: widget.searchStyle,
              //     decoration: widget.searchDecoration,
              //     onChanged: _filterElements,
              //   ),
              // ),
              
              Container(
                height: 40,
                // color: Colors.red,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      // hintText: 'Subject',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 28.0, right: 10),
                        child: Icon(Icons.search),
                      )
                  ),
                  style: widget.searchStyle,
                  onChanged: _filterElements
                ),
              ),

            Divider(height: 8,),


            Expanded(
              child: Container(
                color: Color(0xFFFCFBFF),
                width: widget.size?.width ?? MediaQuery.of(context).size.width,
                height: widget.size?.height ?? MediaQuery.of(context).size.height,
                child: ListView(
                  children: 
                  ListTile.divideTiles(
                    context: context,
                    tiles: 
                    [
                      // widget.favoriteElements.isEmpty
                      //     ? const DecoratedBox(decoration: BoxDecoration())
                      //     : Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           ...widget.favoriteElements.map(
                      //             (f) => SimpleDialogOption(
                      //               child: _buildOption(f),
                      //               onPressed: () {
                      //                 _selectItem(f);
                      //               },
                      //             ),
                      //           ),
                      //           const Divider(),
                      //         ],
                      //       ),
                      if (filteredElements.isEmpty)
                        _buildEmptySearchWidget(context)
                      else
                        ...filteredElements.map(
                          (e) => SimpleDialogOption(
                            key: Key(_toMap(e)[widget.field].toString()),
                            child: _buildOption(e),
                            onPressed: () {
                              _selectItem(e);
                            },
                          ),
                        ),
                    ],
                  ).toList()
                ),
              ),
            ),
          ],
          // )
          // ,
          // children: [

          // ],
            )
          )
        );
  }

  Widget _buildOption(dynamic e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              _toMap(e)[widget.field].toString(),
              // widget.showCountryOnly
              //     ? e.toCountryStringOnly()
              //     : e.toLongString(),
              overflow: TextOverflow.fade,
              style: widget.textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(
      child: Text('No se encontraron coincidencias'),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase()
      .replaceAll("É", "E")
      .replaceAll("Í", "I")
      .replaceAll("Á", "A")
      .replaceAll("Ó", "O")
      .replaceAll("Ú", "U");
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              _toMap(e)[widget.field].toUpperCase()
                .replaceAll("É", "E")
                .replaceAll("Í", "I")
                .replaceAll("Á", "A")
                .replaceAll("Ó", "O")
                .replaceAll("Ú", "U")
                .contains(s))
          .toList();
    });
  }

  Map<String, dynamic> _toMap(dynamic e) {
    var json = e.toJson();
    return {
      'nombre': json["nombre"],
      'opcion': json["opcion"],
      'tipo': json["tipo"],
    };
  }

  void _selectItem(dynamic e) {
    Navigator.of(context).pop(e);
  }
}
