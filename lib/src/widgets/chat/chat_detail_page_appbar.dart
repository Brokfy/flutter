import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../providers/admin_chat_provider.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../models/admin_model.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDetailPageAppBar extends StatelessWidget {
  final String nombre;
  final String img;
  final String bearer;
  final bool isNew;
  final AdminModel admin;

  ChatDetailPageAppBar(
      {@required this.nombre,
      @required this.img,
      @required this.isNew,
      this.admin,
      this.bearer});
  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0178DE),
        flexibleSpace: _appBarChatNuevo(context)
        /*this.isNew ? _appBarChatNuevo(context) //: _appBarChatAntiguo(context),
          : Container(), */
        );
  }

  Widget _appBarChatAntiguo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
      child: AppBar(
        leading: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
          ),
          child: IconButton(
              onPressed: () {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Color(0xFFF9FAFA),
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: Color(0xFFF9FAFA),
                  systemNavigationBarDividerColor: Colors.grey,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ));
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(0.0),
              icon: Image.asset(
                'assets/images/icons/Chat_Back@3x.png',
                filterQuality: FilterQuality.high,
              )),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF202D39),
        ),
        backgroundColor: Color(0xFF0079DE),
        title: Container(
          // padding: EdgeInsets.only(right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(4)),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          this.nombre,
                          style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: ScreenUtil().setSp(17),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Text(
                          "Asesor de seguros",
                          style: TextStyle(
                              fontFamily: 'SF Pro',
                              fontSize: ScreenUtil().setSp(15),
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0.0),
                  icon: Image.asset(
                    'assets/images/icons/Chat_Call@3x.png',
                    filterQuality: FilterQuality.high,
                  ))),
          SizedBox(
            width: ScreenUtil().setWidth(12),
          ),
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                  // onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
                  onPressed: () {},
                  padding: EdgeInsets.all(0.0),
                  icon: Image.asset(
                    'assets/images/icons/Chat_Profile@3x.png',
                    filterQuality: FilterQuality.high,
                  ))),
        ],
      ),
    );

    // return Container(
    //   child: Padding(
    //     padding: EdgeInsets.only(top: 20),
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //           flex: 2, // 20%
    //           child: SizedBox(
    //             height: 45.0,
    //             width: 45.0,
    //             child: IconButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 padding: EdgeInsets.all(0.0),
    //                 icon: Image.asset(
    //                   'assets/images/icons/Chat_Back@3x.png',
    //                   filterQuality: FilterQuality.high,
    //                 )),
    //           ),
    //         ),
    //         Expanded(
    //           flex: 4,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 this.nombre,
    //                 style: TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w600,
    //                     color: Colors.white),
    //               ),
    //               SizedBox(
    //                 height: 1,
    //               ),
    //               Text(
    //                 "Asesor de seguros",
    //                 style: TextStyle(color: Colors.white, fontSize: 12),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2, // 20%
    //           child: SizedBox(
    //               height: 45.0,
    //               width: 45.0,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   IconButton(
    //                       onPressed: () {},
    //                       padding: EdgeInsets.all(0.0),
    //                       icon: Image.asset(
    //                         'assets/images/icons/Chat_Call@3x.png',
    //                         filterQuality: FilterQuality.high,
    //                       )),
    //                 ],
    //               )),
    //         ),
    //         Expanded(
    //           flex: 2, // 20%
    //           child: SizedBox(
    //               height: 45.0,
    //               width: 45.0,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   IconButton(
    //                       onPressed: () {},
    //                       padding: EdgeInsets.all(0.0),
    //                       icon: Image.asset(
    //                         'assets/images/icons/Chat_Profile@3x.png',
    //                         filterQuality: FilterQuality.high,
    //                       )),
    //                 ],
    //               )),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _appBarChatNuevo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
      child: AppBar(
        leading: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(10),
          ),
          child: IconButton(
              onPressed: () {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Color(0xFFF9FAFA),
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: Color(0xFFF9FAFA),
                  systemNavigationBarDividerColor: Colors.grey,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ));
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(0.0),
              icon: Image.asset(
                'assets/images/icons/Chat_Back@3x.png',
                filterQuality: FilterQuality.high,
              )),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF202D39),
        ),
        backgroundColor: Color(0xFF0079DE),
        title: Container(
          // padding: EdgeInsets.only(right: 16),
          child: (this.admin == null)
              ? _animacionSkeleton(context)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(4)),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Text(
                                admin.nombre,
                                style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: ScreenUtil().setSp(17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(8)),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Text(
                                "Asesor de seguros",
                                style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(0.0),
                  icon: Image.asset(
                    'assets/images/icons/Chat_Call@3x.png',
                    filterQuality: FilterQuality.high,
                  ))),
          SizedBox(
            width: ScreenUtil().setWidth(12),
          ),
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                  // onPressed: () => Navigator.of(context).pushReplacementNamed('home'),
                  onPressed: () {},
                  padding: EdgeInsets.all(0.0),
                  icon: Image.asset(
                    'assets/images/icons/Chat_Profile@3x.png',
                    filterQuality: FilterQuality.high,
                  ))),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _animacionSkeleton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setHeight(8)),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SkeletonAnimation(
                    child: Container(
                      height: ScreenUtil().setHeight(30),
                      width: ScreenUtil().setWidth(180),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setHeight(8)),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SkeletonAnimation(
                    child: Container(
                      height: ScreenUtil().setHeight(25),
                      width: ScreenUtil().setWidth(120),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
