import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ImageViewerPage extends StatefulWidget {
  String path;

  ImageViewerPage({@required this.path});
  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Imagen',
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
              Center(child: Image.network(widget.path)),
              Positioned(
                top: 30,
                left: 20,
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
            ])));
  }
}
