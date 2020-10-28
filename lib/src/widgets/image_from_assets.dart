import 'package:flutter/material.dart';

class ImageFromAssets extends StatelessWidget {
  final String assetName;
  final double width;

  const ImageFromAssets({
    Key key, 
    @required this.assetName,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/$assetName.png', width: width);
  }
}