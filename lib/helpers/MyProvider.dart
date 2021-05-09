import 'package:flutter/foundation.dart';
import 'package:greca/models/Charge.dart';
import 'package:greca/models/ChargeInfo.dart';
import 'package:greca/models/OrderDetail.dart';
import 'package:greca/models/OrderModel.dart';
import 'package:greca/models/TransInfo.dart';
import 'package:greca/models/Transaction.dart';
import 'package:greca/module/orders_module.dart';

class MyProvider with ChangeNotifier{
  bool _isShowServiceView = false;
  bool _isShowOrderView = true;
  bool _isShowPriceView = false;
  bool dashboard_status = false;
  Order selected_order;
  OrderDetail order_detail;
  TransInfo seleted_transaction;
  ChargeInfo selected_charge;
  bool isTransShow = true;

  bool get getIsShowServiceView => _isShowServiceView;
  set setIsShowServiceView(bool value){
    _isShowServiceView = value;
    notifyListeners();
  }
  bool get getDashboradView => dashboard_status;
  set setDashboardView(bool value) {
    dashboard_status = value;
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

  Future getOrderDetail(int id) async {
    _isSecondOrdersView = true;
    _isMainOrdersView = false;
    await OrdersModule.getOrderDetail(id).then((value){
      if(value != null){
        order_detail = value;
        print("---travel date:${order_detail.arrival}");
      }
    });
    notifyListeners();
  }

}