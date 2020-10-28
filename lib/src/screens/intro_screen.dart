// import 'package:auto_size_text/auto_size_text.dart';
import 'package:brokfy_app/src/models/slidershow_model.dart';
import 'package:brokfy_app/src/services/preferences_service.dart';
import 'package:brokfy_app/src/widgets/hex_color.dart';
import 'package:brokfy_app/src/widgets/image_from_assets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageIndex;
  PreferencesService pref; 

  @override
  void initState() { 
    super.initState();
    pageIndex = 0;
    pref = new PreferencesService();
  }

  void nextPage() => setState(() { pageIndex++; });
  void previousPage() => setState(() { pageIndex--; });
  void moveToPage(BuildContext context) {
    final pageViewIndex = Provider.of<SliderShowModel>(context, listen: false).currentPage;
    if( pageViewIndex == pageViewIndex.roundToDouble().toInt() ) {
      setState(() { pageIndex = pageViewIndex.roundToDouble().toInt(); });
    }
  }
  void skip() {
    pref.skippedIntro = true;
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    return ChangeNotifierProvider(
      create: (_) => new SliderShowModel(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: HexColor("#1F92F3"),
          body: Column(
            children: [
              Flexible(
                flex: 4,
                child: Container(),
              ),

              Flexible(
                flex: 6,
                child: Container(
                  height: double.infinity,
                  child:  FractionallySizedBox(
                    // heightFactor: 0.6,
                    child: Image.asset('assets/images/Logo Small.png'),
                  )
                ),
              ),


              Flexible(
                flex: 2,
                child: Container(),
              ),

              Flexible(
                flex: 35,
                child: _Slides(pageIndex: pageIndex, nextPage: nextPage, previousPage: previousPage, moveToPage: moveToPage),
              ),


              Flexible(
                flex: 2,
                child: Container(),
              ),

              Flexible(
                flex: 39,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(2.0, 3.0)
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 15,
                        child: Container(height: double.infinity,),
                      ),
                      Flexible(
                        flex: 45,
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          child: Builder(builder: (BuildContext context) {
                            final pageViewIndex = Provider.of<SliderShowModel>(context, listen: true).currentPage;

                            final mensajes = [
                              "Tus seguros en un mismo lugar",
                              "El mejor seguro para ti",
                              "Adiós largas esperas",
                              "El mejor servicio para ti",
                            ];

                            return FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Text(
                                mensajes[pageViewIndex.roundToDouble().toInt()],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20.5),
                                  fontFamily: 'SF Pro', 
                                  color: HexColor("#202D39")
                                )
                              )
                              // LayoutBuilder(builder: (context, constraint) {
                              //   return Text(
                              //     mensajes[pageViewIndex.roundToDouble().toInt()],
                              //     style: DefaultTextStyle.of(context).style.copyWith(
                              //       fontWeight: FontWeight.bold
                              //     ).apply(
                              //       fontSizeFactor: constraint.biggest.width/220.0
                              //     ),
                              //     maxLines: 1,
                              //     overflow: TextOverflow.ellipsis,
                              //     textAlign: TextAlign.start,
                              //   );
                              // }),                              
                              // AutoSizeText(
                              //   mensajes[pageViewIndex.roundToDouble().toInt()],
                              //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              //   minFontSize: 16,
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //   textAlign: TextAlign.start,
                              // ),
                            );
                          }),
                        ),
                      ),
                      Flexible(
                        flex: 50,
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          child: Builder(builder: (BuildContext context) {
                            final pageViewIndex = Provider.of<SliderShowModel>(context, listen: true).currentPage;

                            final mensajes = [
                              "Gestiona todos tus seguros de las mejores compañías aseguradoras en México en una sola plataforma y completamente gratis.",
                              "Tenemos las mejores opciones de seguros para que encuentres la que mejor se adapte a tus necesidades y perfil.",
                              "Para Brokfy tú eres lo más importante, por eso te brindamos asesoría personalizada 24/7, los 365 días del año.",
                              "¡Queremos brindarte el mejor servicio! Ayúdanos contestando las siguientes preguntas para poder mejorar nuestro servicio.",
                            ];

                            return FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Text(
                                mensajes[pageViewIndex.roundToDouble().toInt()],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontFamily: 'SF Pro', 
                                  color: HexColor("#5A666F"),
                                ),
                              ),
                              // LayoutBuilder(builder: (context, constraint) {
                              //   return Text(
                              //     mensajes[pageViewIndex.roundToDouble().toInt()],
                              //     style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: constraint.biggest.width/310.0),
                              //     maxLines: 3,
                              //     overflow: TextOverflow.ellipsis,
                              //     textAlign: TextAlign.start,
                              //   );
                              // })
                              
                              // AutoSizeText(
                              //   mensajes[pageViewIndex.roundToDouble().toInt()],
                              //   style: TextStyle(fontSize: 20),
                              //   minFontSize: 14,
                              //   maxLines: 3,
                              //   overflow: TextOverflow.ellipsis,
                              //   textAlign: TextAlign.start,
                              // ),
                            );
                          }),
                        ),
                      ),
                      Flexible(
                        flex: 10,
                        child: Container(height: double.infinity,),
                      ),
                      Flexible(
                        flex: 30,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _Dots()
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 25,
                                  child: 
                                  Container(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.expand(),
                                      child: IconButton(
                                        onPressed: (){
                                          if ( pageIndex < 3 ) {
                                            setState(() {
                                              pageIndex++;
                                            });
                                          } else {
                                            skip();
                                          }
                                        },
                                        padding: EdgeInsets.all(0.0),
                                        icon: Image.asset('assets/images/button.png', filterQuality: FilterQuality.high,)
                                      )
                                    )
                                  )

                                  // Container(
                                  //   width: double.infinity,
                                  //   height: double.infinity,
                                  //   child: IconButton(
                                  //     icon: Image.asset('assets/images/button.png'),
                                  //     onPressed: () {},
                                  //   ),
                                  // )

                                  // child: Container(
                                  //   width: double.infinity,
                                  //   height: double.infinity,
                                  //   decoration: BoxDecoration(
                                  //     shape: BoxShape.circle,
                                  //     gradient: LinearGradient(
                                  //       colors: [HexColor("#1F92F3"), HexColor("#0079DE")],
                                  //       begin: Alignment.topCenter,
                                  //       end: Alignment.bottomCenter,
                                  //       tileMode: TileMode.clamp
                                  //     ),
                                  //     boxShadow: [
                                  //       BoxShadow(
                                  //         color: HexColor("#0079DE").withOpacity(0.5),
                                  //         spreadRadius: 0,
                                  //         blurRadius: 9,
                                  //         offset: Offset(0, 3), // changes position of shadow
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   child: new RawMaterialButton(
                                  //     shape: new CircleBorder(),
                                  //     elevation: 0.0,
                                  //     child: new LayoutBuilder(
                                  //       builder: (context, constraint) {
                                  //         return new Icon(
                                  //           Icons.arrow_forward,
                                  //           color: Colors.white,
                                  //           size: constraint.biggest.height * 0.5,
                                  //         );
                                  //       }
                                  //     ),
                                  //     onPressed: (){
                                  //       if ( pageIndex < 3 ) {
                                  //         setState(() {
                                  //           pageIndex++;
                                  //         });
                                  //       } else {
                                  //         skip();
                                  //       }
                                  //     },
                                  //   )
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 10,
                        child: Container(height: double.infinity,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slides extends StatefulWidget {
  final int pageIndex;
  final Function nextPage;
  final Function previousPage;
  final Function moveToPage;

  const _Slides({
    Key key, 
    @required this.pageIndex,
    @required this.nextPage,
    @required this.previousPage,
    @required this.moveToPage
  }) : super(key: key);
  
  @override
  __SlidesState createState() => __SlidesState();
}

class __SlidesState extends State<_Slides> {
  final pageViewController = new PageController();

  @override
  void initState() { 
    super.initState();
    pageViewController.addListener(() {
      Provider.of<SliderShowModel>(context, listen: false).currentPage = pageViewController.page;
      this.widget.moveToPage(context);
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    if (pageViewController.hasClients) {
      pageViewController.animateToPage(
        this.widget.pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Container(
      child: PageView(
        controller: pageViewController,
        children: <Widget>[
          _Slide(content: ImageFromAssets( assetName: 'intro_slide_1', width: 250.0 )),
          _Slide(content: ImageFromAssets( assetName: 'intro_slide_2', width: 185.0 )),
          _Slide(content: ImageFromAssets( assetName: 'intro_slide_3', width: 185.0 )),
          _Slide(content: ImageFromAssets( assetName: 'intro_slide_4', width: 185.0 )),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.0,
      // margin: EdgeInsets.only(bottom: 30.0),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Dot(index: 0,),
          _Dot(index: 1,),
          _Dot(index: 2,),
          _Dot(index: 3,),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int index;

  const _Dot({
    Key key,
    @required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageViewIndex = Provider.of<SliderShowModel>(context).currentPage;

    return LayoutBuilder(
      builder: (context, constraint) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 16,
          height: 16,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: pageViewIndex >= index - 0.5  && pageViewIndex < index + 0.5 ? HexColor("#0079DE") : HexColor("#D8D8D8"),
            // border: Border.all(width: 1, color: Colors.white, style: BorderStyle.solid),
            shape: BoxShape.circle
          ),
        );
      }
    );
  }
}

class _Slide extends StatelessWidget {
  final Widget content;

  const _Slide({
    Key key, 
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(30.0),
      child: content,
    );
  }
}
