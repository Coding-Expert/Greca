import 'package:flutter/foundation.dart';

class MyProvider with ChangeNotifier{
  bool _isShowServiceView = false;
  bool _isShowOrderView = true;
  bool _isShowPriceView = false;

  bool get getIsShowServiceView => _isShowServiceView;
  set setIsShowServiceView(bool value){
    _isShowServiceView = value;
    notifyListeners();
  }

  bool get getIsShowOrderView => _isShowOrderView;
  set setIsShowOrderView(bool value){
    _isShowOrderView = value;
    notifyListeners();
  }

  bool get getIsShowPriceView => _isShowPriceView;
  set setIsShowPriceView(bool value){
    _isShowPriceView = value;
    notifyListeners();
  }

  bool _isMainOrdersView = true;
  bool get getIsMainOrdersView => _isMainOrdersView;
  set setIsMainOrdersView(bool value){
    _isMainOrdersView = value;
    notifyListeners();
  }

  bool _isSecondOrdersView = false;
  bool get getIsSecondOrdersView => _isSecondOrdersView;
  set setIsSecondOrdersView(bool value){
    _isSecondOrdersView = value;
    notifyListeners();
  }

  bool _isThreeOrdersView = false;
  bool get getIsThreeOrdersView => _isThreeOrdersView;
  set setIsThreeOrdersView(bool value){
    _isThreeOrdersView = value;
    notifyListeners();
  }

}