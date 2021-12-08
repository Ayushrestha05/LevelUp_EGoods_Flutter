import 'package:flutter/material.dart';

class SizeConfig {
  static const double mockupHeight = 640;
  static const double mockupWidth = 360;

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;
  static late double scale;
  static late double textScaleFactor;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    scale = mockupWidth / _mediaQueryData.size.width;
    textScaleFactor = _mediaQueryData.size.width / mockupWidth;
  }
}

double rWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return inputWidth / SizeConfig.mockupWidth * screenWidth;
}
