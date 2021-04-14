
import 'package:flutter/material.dart';

class TempleteServiceModel{
  int index;
  String title;
  String imageAsset;
  String icon;
  Color colorBg;

  TempleteServiceModel({
    this.index,
    this.title,
    this.imageAsset,
    this.colorBg
  });

  int get getIndex => index;
  set setIndex(int newValue){
    index = newValue;
  }

  String get getTitle => title;
  set setTitle(String newValue){
    title = newValue;
  }

  String get getImageAssets => imageAsset;
  set setImageAssets(String newValue){
    imageAsset = newValue;
  }

  String get getIcon => icon;
  set setIcon(String newValue){
    icon = newValue;
  }

  Color get getColorBg => colorBg;
  set setColorBg(Color newColor){
    colorBg = newColor;
  }

}