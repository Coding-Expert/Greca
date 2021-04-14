import 'package:flutter/material.dart';

class ScreenSize{
  BuildContext context;

  ScreenSize(this.context);

  getHeight(){
    return MediaQuery.of(context).size.height;
  }

  getWidth(){
    return MediaQuery.of(context).size.width;
  }

  getOrientation(){
    return MediaQuery.of(context).orientation;
  }

}