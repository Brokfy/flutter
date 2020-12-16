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
  final bool multiple;

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
    this.field,
    this.multiple = false,
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
  var selecciones = [];

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

            if (!widget.multiple)
            Divider(height: 8,),

            if (!widget.hideSearch && !widget.multiple)
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

            if (!widget.hideSearch && !widget.multiple)
              Divider(height: 8,),


            if (!widget.multiple) 
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

            if (widget.multiple) 
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(32),
                  left: ScreenUtil().setWidth(42),
                ),
                color: Color(0xFFFCFBFF),
                width: widget.size?.width ?? MediaQuery.of(context).size.width,
                height: widget.size?.height ?? MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: ScreenUtil().setWidth(42),),
                      child: Text(
                        'Porfavor selecciona la(s) medidas de seguridad con las que cuenta tu vivienda,  en caso de no tener ninguna selecciona “ninguna de las anteriores”.',
                        style: TextStyle(
                          color: Color(0xFF5A666F),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(15),
                          fontFamily: 'SF Pro', 
                        ),
                      ),
                    ),

                    SizedBox(height: ScreenUtil().setHeight(32),),

                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.elements.length, 
                        itemBuilder: (BuildContext context,int index) { 

                          seleccionarItem() {
                            var item = widget.elements[index];
                            var idSeleccionado = item.id;
                            if( selecciones.length == 0 ) {
                              selecciones.add(widget.elements[index]);
                            } else {
                              if ( selecciones.where((element) => element.id == idSeleccionado).isNotEmpty ) {
                                selecciones.removeWhere((element) => element.id == idSeleccionado);
                              } else {
                                selecciones.add(widget.elements[index]);
                              }
                            }
                            setState(() {});
                          }

                          return ListTile( 
                            dense: true,
                            title: Wrap(
                              children: [
                                SizedBox(height: 8,), 

                                InkWell(
                                  onTap: () => seleccionarItem(),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          child: Checkbox(
                                            value: selecciones.where((element) => element.id == widget.elements[index].id).isNotEmpty,
                                            onChanged: (value) => seleccionarItem(),   
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _toMap(widget.elements[index])[widget.field],
                                            style: TextStyle(
                                              color: Color(0xFF5A666F),
                                              fontWeight: FontWeight.w500,
                                              fontSize: ScreenUtil().setSp(15),
                                              fontFamily: 'SF Pro', 
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 2.0,
                                  margin: EdgeInsets.only(
                                    top: 12
                                  ),
                                  color: Color(0xFFDBE6F0),
                                  // child: Divider(, )
                                ),
                                SizedBox(height: 8,), 
                              ],
                            )
                          ); 
                        } 
                      ),
                    ), 

                  ],
                ),
              )
            ),


    if( widget.multiple )
     Container(
       decoration: BoxDecoration(
         color: Color(0xFFFFFFFF),
         border: Border(
           top: BorderSide(
              color: Color(0xFFDBE6F0),
              width: 1
            )
         ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDBE6F0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Container(
          height: ScreenUtil().setHeight(60),
          margin: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(28),
            horizontal: ScreenUtil().setWidth(50),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF0079DE).withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: ScreenUtil().setHeight(9),
                offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
              ),
            ],
          ),
          child: RaisedButton(
            onPressed: () async {
              _returnList(selecciones);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            splashColor: Color.fromRGBO(255, 255, 255, 0.2),
            disabledColor: Color(0xFFC4C4C4),
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                color: Color(0xFFC4C4C4),
                gradient: LinearGradient(
                  colors: [Color(0xFF1F92F3), Color(0xFF0079DE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Seleccionar medidas de seguridad",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(15),
                        fontFamily: 'SF Pro', 
                      ),
                    ),

                    Container(
                      width: ScreenUtil().setWidth(38),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 10,
                            top: 0,
                            child: Icon(Icons.chevron_right, color: Colors.white)
                          ),
                          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3))
                        ]
                      ),
                    )
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      )
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
      'colonia': json["colonia"],
      "etiqueta": json["etiqueta"],
    };
  }

  void _selectItem(dynamic e) {
    Navigator.of(context).pop(e);
  }

  void _returnList(List<dynamic> e) {
    Navigator.of(context).pop(e);
  }
}
