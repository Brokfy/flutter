import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PolizasScreen extends StatefulWidget {
  @override
  _PolizasScreenState createState() => _PolizasScreenState();
}

class _PolizasScreenState extends State<PolizasScreen> {
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    return Column(
      children: [
        Flexible(
          flex: 8,
          child: Placeholder(),
        ),
        _btnAddPolizaBuild()
      ],
    );
  }

  Widget _btnAddPolizaBuild() {
    return Flexible(
      flex: 1,
      child: Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(40),
          right: ScreenUtil().setWidth(41),
          top: ScreenUtil().setHeight(10),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: ScreenUtil().setHeight(9),
              offset: Offset(0, ScreenUtil().setHeight(3)), // changes position of shadow
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed("chat_poliza"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5.0)
            ),
            child: Container(
              // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "Añadir Póliza",
                style: TextStyle(
                  color: HexColor("#FFFFFF"),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(15),
                  fontFamily: 'SF Pro', 
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return Column(
//       children: [
//         Container(
//           height: height * 0.24,
//           child: Column(
//             children: [
//               PolizasTituloOpciones(height: height, width: width),
//               ResumenGastos(height: height, width: width),
//             ],
//           ),
//         ),

//         TuScoreAsegurado(height: height, width: width),
//         Aseguramiento(height: height, width: width),
//         FiltroPolizasCartaNombramiento(height: height, width: width),

//         Expanded(
//           child: LayoutBuilder(builder: (context, constraints) {
//             return Container(
//               height: constraints.biggest.height,
//               margin: EdgeInsets.only(
//                 top: constraints.biggest.height * 0.00,
//                 // bottom: constraints.biggest.height * 0.12
//               ),
//               // color: Colors.red,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 physics: BouncingScrollPhysics(),
//                 children: <Widget>[
//                   Container(
//                     width: width * 0.06,
//                     color: Colors.transparent,
//                   ),
//                   ItemPoliza(
//                     width: width, 
//                     height: height,
//                     nombre: 'Gastos Médicos',
//                     color: "#0079DE", 
//                     logo: Placeholder(), 
//                     valor: '\$18,500', 
//                     vcto: 'Exp: 11/2018',
//                     periodicidad: 'Anual',
//                   ),
//                   ItemPoliza(
//                     width: width, 
//                     height: height,
//                     nombre: 'Auto',
//                     color: "#FF666A", 
//                     logo: Placeholder(), 
//                     valor: '\$2,000', 
//                     vcto: 'Exp: 11/2018',
//                     periodicidad: 'Mensual',
//                   ),
//                   ItemPoliza(
//                     width: width, 
//                     height: height,
//                     nombre: 'Auto',
//                     color: "#64BA00", 
//                     logo: Placeholder(), 
//                     valor: '\$1,300', 
//                     vcto: 'Exp: 11/2018',
//                     periodicidad: 'Mensual',
//                   ),
//                   Container(
//                     width: width * 0.04,
//                     color: Colors.transparent,
//                   ),
//                 ],
//               ),
//             );
//           },),
//         ),

//         BotonAnadirPoliza(height: height, width: width),
//       ],
//     );
//   }
// }

class BotonAnadirPoliza extends StatelessWidget {
  const BotonAnadirPoliza({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: height * 0.02,
        bottom: height * 0.015,
        left: width * 0.07,
        right: width * 0.07,
      ),
      child: Container(
        height: height * 0.07,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#0079DE").withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: height * 0.01,
              offset: Offset(0, height * 0.0033),
            ),
          ],
        ),
        child: RaisedButton(
          onPressed: () {
            // Navigator.pushNamed(context, 'crear_password');
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height * 0.0078)),
          splashColor: Color.fromRGBO(255, 255, 255, 0.2),
          disabledColor: HexColor("#C4C4C4"),
          textColor: Colors.white,
          disabledTextColor: Colors.white,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#C4C4C4"),
              gradient: LinearGradient(
                colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(height * 0.0078)
            ),
            child: Container(
              // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                "AÑADIR PÓLIZA",
                style: TextStyle(
                  fontSize: (height / width) * 8,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FiltroPolizasCartaNombramiento extends StatelessWidget {
  const FiltroPolizasCartaNombramiento({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.05,
      child: Container(
        margin: EdgeInsets.only(
          bottom: height * 0.00,
          left: width * 0.07,
          right: width * 0.07,
        ),
        child: Container(
          child: Container(
            padding: EdgeInsets.all(height * 0.0044),
            height: height * 0.07,
            decoration: BoxDecoration(
              color: HexColor("#E8E9EA"),
              borderRadius: BorderRadius.circular(50),
            ),
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: (height / width) * 8.2,
                  fontWeight: FontWeight.bold
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#C9CACB"),
                      spreadRadius: 0,
                      blurRadius: height * 0.0044,
                      offset: Offset(0, height * 0.0033), // changes position of shadow
                    ),
                  ],
                ),
                tabs: [
                  Tab(text: "Mis Pólizas",),
                  Tab(text: "Carta Nombramiento",),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Aseguramiento extends StatelessWidget {
  const Aseguramiento({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.1383,
      margin: EdgeInsets.only(
        top: height * 0.02,
        bottom: height * 0.02,
      ),
      child: Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              width: width * 0.06,
              color: Colors.transparent,
            ),
            ItemAsegurado(
              width: width, 
              height: height,
              nombre: "Vida",
              porcentaje: 78,
              color: "#0079DE",
            ),
            ItemAsegurado(
              width: width, 
              height: height,
              nombre: "Médicos",
              porcentaje: 15,
              color: "#FF666A",
            ),
            ItemAsegurado(
              width: width, 
              height: height,
              nombre: "Autos",
              porcentaje: 35,
              color: "#64BA00",
            ),
            ItemAsegurado(
              width: width, 
              height: height,
              nombre: "Propiedades",
              porcentaje: 50,
              color: "#5A666F",
            ),
            Container(
              width: width * 0.04,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemPoliza extends StatelessWidget {
  const ItemPoliza({
    Key key,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.nombre,
    @required this.vcto,
    @required this.logo,
    @required this.valor,
    @required this.periodicidad,
  }) : super(key: key);

  final double width;
  final double height;
  final String color;
  final Widget logo;
  final String nombre;
  final String vcto;
  final String valor;
  final String periodicidad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.34,
      margin: EdgeInsets.only(
        right: width * 0.03,
      ),
      color: Colors.transparent,
      child: Container(
        height: 20,
        width: 20,
        margin: EdgeInsets.symmetric(vertical: height * 0.015),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.03),
          boxShadow: [
            BoxShadow(
              color: HexColor("#C9CACB").withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 9,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 4,),
            Container(
              width: width * 0.25,
              height: height * 0.07,
              child: this.logo,
            ),
            Column(
              children: [
                Text(
                  this.nombre,
                  style: TextStyle(
                    color: HexColor("#5A666F"),
                    fontSize: (height / width) * 9,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  this.vcto,
                  style: TextStyle(
                    color: HexColor("#5A666F"),
                    fontSize: (height / width) * 6.5,
                  ),
                ),
              ],
            ),
            Container(
              width: width * 0.2898,
              height: height * 0.044,
              decoration: BoxDecoration(
                color: HexColor(this.color),
                borderRadius: BorderRadius.circular(7)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.valor,
                    style: TextStyle(
                      fontSize: (height / width) * 8.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    ' ${this.periodicidad}',
                    style: TextStyle(
                      fontSize: (height / width) * 8.5,
                      color: Colors.white,
                    )
                  )
                ],
              )
            ),
            SizedBox(height: 4,),
          ],
        ),
      ),
    );
  }
}

class ItemAsegurado extends StatelessWidget {
  const ItemAsegurado({
    Key key,
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.porcentaje,
    @required this.nombre,
  }) : super(key: key);

  final double width;
  final double height;
  final String color;
  final double porcentaje;
  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.34,
      margin: EdgeInsets.only(
        right: width * 0.03,
        bottom: width * 0.015,
      ),
      color: Colors.transparent,
      child: Container(
        height: 20,
        width: 20,
        // margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.03),
          boxShadow: [
            BoxShadow(
              color: HexColor("#C9CACB").withOpacity(0.7),
              spreadRadius: 0,
              blurRadius: 9,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              this.nombre,
              style: TextStyle(
                color: HexColor("#5A666F"),
                fontSize: (height / width) * 10.2,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              height: height * 0.01,
              width: width * 0.2898,
              decoration: BoxDecoration(
                color: HexColor("#EDEDED"),
                borderRadius: BorderRadius.circular(width * 0.007),
              ),
              padding: EdgeInsets.symmetric(vertical: height * 0.0009),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: this.porcentaje / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor(this.color),
                      borderRadius: BorderRadius.circular(width * 0.007),
                    ),
                  ),
                ),
              )
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.0022,
                bottom: height * 0.0044,
              ),
              child: Text(
                '${this.porcentaje.toString()}% Completado',
                style: TextStyle(
                  color: HexColor("#5A666F"),
                  fontSize: (height / width) * 8,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TuScoreAsegurado extends StatelessWidget {
  const TuScoreAsegurado({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.081,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Row(
          children: [
            Container(
              width: width  * 0.43,
              child: Text(
                'Tu score asegurado',
                style: TextStyle(
                  color: HexColor("#202D39"),
                  fontSize: (height / width) * 9.5,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),
            ),

            Container(
              alignment: Alignment.centerRight,
              width: width  * 0.43,
              child: 
              Container(
                height: height * 0.07,
                width: width * 0.34,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#0079DE").withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: height * 0.01,
                      offset: Offset(0, height * 0.0033),
                    ),
                  ],
                ),
                child: RaisedButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, 'crear_password');
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height * 0.0078)),
                  splashColor: Color.fromRGBO(255, 255, 255, 0.2),
                  disabledColor: HexColor("#C4C4C4"),
                  textColor: Colors.white,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: HexColor("#C4C4C4"),
                      gradient: LinearGradient(
                        colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(height * 0.0078)
                    ),
                    child: Container(
                      // constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Mejorar mi score",
                        style: TextStyle(
                          fontSize: (height / width) * 8,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class ResumenGastos extends StatelessWidget {
  const ResumenGastos({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.31,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "\$2.000",
                    style: TextStyle(
                      fontSize: (height / width) * 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor("##1F92F3"),
                    )
                  ),
                ),
                SizedBox(width: width * 0.04,),
                Container(
                  width: width * 0.31,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "\$24.000",
                    style: TextStyle(
                      fontSize: (height / width) * 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor("##1F92F3"),
                    )
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.03,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.31,
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Gasto Mensual",
                    style: TextStyle(
                      fontSize: (height / width) * 9,
                      color: HexColor("##1F92F3"),
                    )
                  ),
                ),
                SizedBox(width: width * 0.04,),
                Container(
                  width: width * 0.31,
                  alignment: Alignment.center,
                  child: Text(
                    "Gasto Anual",
                    style: TextStyle(
                      fontSize: (height / width) * 9,
                      color: HexColor("##1F92F3"),
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PolizasTituloOpciones extends StatelessWidget {
  const PolizasTituloOpciones({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: width * 0.11,
            alignment: Alignment.centerRight,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: 200.0,
                height: 200.0,
                // margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#0079DE").withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 9,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  elevation: 0.0,
                  child: Icon( 
                    Icons.person,
                    size: width * 0.09,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ),

          Container(
            child: Image.asset('assets/images/brokfy_azul2.png', width: width * 0.31),
          ),

          Container(
            height: width * 0.11,
            alignment: Alignment.centerRight,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: 200.0,
                height: 200.0,
                // margin: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor("#0079DE").withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 9,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: new RawMaterialButton(
                  shape: new CircleBorder(),
                  elevation: 0.0,
                  child: Icon( 
                    MdiIcons.message,
                    size: width * 0.07,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

