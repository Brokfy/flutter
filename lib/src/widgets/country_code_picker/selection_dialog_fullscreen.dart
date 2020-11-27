import 'package:flutter/material.dart';
import 'country_code.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// selection dialog used for selection of the country code
class SelectionDialogFullScreen extends StatefulWidget {
  final List<CountryCode> elements;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle textStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showFlag;
  final double flagWidth;
  final Size size;
  final bool hideSearch;
  final String title;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialogFullScreen(
    this.elements,
    this.favoriteElements, {
    Key key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.showFlag,
    this.flagWidth = 32,
    this.size,
    this.hideSearch = false,
    this.title,
  })  : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration =
            searchDecoration.copyWith(prefixIcon: Icon(Icons.search)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogFullScreen();
}

class _SelectionDialogFullScreen extends State<SelectionDialogFullScreen> {
  /// this is useful for filtering purpose
  List<CountryCode> filteredElements;

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
                height:
                    widget.size?.height ?? MediaQuery.of(context).size.height * 0.7,
                child: ListView(
                    children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    widget.favoriteElements.isEmpty
                        ? const DecoratedBox(decoration: BoxDecoration())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.favoriteElements.map(
                                (f) => SimpleDialogOption(
                                  child: _buildOption(f),
                                  onPressed: () {
                                    _selectItem(f);
                                  },
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                    if (filteredElements.isEmpty)
                      _buildEmptySearchWidget(context)
                    else
                      ...filteredElements.map(
                        (e) => SimpleDialogOption(
                          key: Key(e.toLongString()),
                          child: _buildOption(e),
                          onPressed: () {
                            _selectItem(e);
                          },
                        ),
                      ),
                  ],
                ).toList()),
              ),
            ),
        ]
      )
    ));
  }
  
  // SimpleDialog(
  //       titlePadding: const EdgeInsets.all(0),
  //       title: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: <Widget>[
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 12.0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: 60,
  //                   child: IconButton(
  //                       iconSize: 20,
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       icon: Image.asset(
  //                         'assets/images/Back.png',
  //                         filterQuality: FilterQuality.high,
  //                       )),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     alignment: Alignment.bottomCenter,
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       'Seleccionar País',
  //                       style: TextStyle(
  //                         fontFamily: 'SF Pro',
  //                         color: Color(0xFF202D39),
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: 60,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Divider(
  //             height: 8,
  //           ),
  //           if (!widget.hideSearch)
  //             // Padding(
  //             //   padding: const EdgeInsets.symmetric(horizontal: 24),
  //             //   child: TextField(
  //             //     style: widget.searchStyle,
  //             //     decoration: widget.searchDecoration,
  //             //     onChanged: _filterElements,
  //             //   ),
  //             // ),

  //             Container(
  //               height: 40,
  //               // color: Colors.red,
  //               child: TextField(
  //                   decoration: InputDecoration(
  //                       border: InputBorder.none,
  //                       focusedBorder: InputBorder.none,
  //                       contentPadding:
  //                           EdgeInsets.symmetric(vertical: 5, horizontal: 30),
  //                       // hintText: 'Subject',
  //                       prefixIcon: Padding(
  //                         padding: EdgeInsets.only(left: 28.0, right: 10),
  //                         child: Icon(Icons.search),
  //                       )),
  //                   style: widget.searchStyle,
  //                   onChanged: _filterElements),
  //             ),
  //           Divider(
  //             height: 8,
  //           ),
  //         ],
  //       ),
  //       children: ,
  //     );

  Widget _buildOption(CountryCode e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (widget.showFlag)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  e.flagUri,
                  width: widget.flagWidth,
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly
                  ? e.toCountryStringOnly()
                  : e.toLongString(),
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
    s = s
        .toUpperCase()
        .replaceAll("É", "E")
        .replaceAll("Í", "I")
        .replaceAll("Á", "A")
        .replaceAll("Ó", "O")
        .replaceAll("Ú", "U");
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name
                  .toUpperCase()
                  .replaceAll("É", "E")
                  .replaceAll("Í", "I")
                  .replaceAll("Á", "A")
                  .replaceAll("Ó", "O")
                  .replaceAll("Ú", "U")
                  .contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Navigator.pop(context, e);
  }
}
