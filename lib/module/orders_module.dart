
import 'dart:convert';

import 'package:greca/models/OrderDetail.dart';
import 'package:greca/models/OrderModel.dart';
import 'package:greca/module/user_module.dart';
import 'package:http/http.dart' as http;

class OrdersModule {
  static List<Order> order_list = [];
  static OrderDetail order_detail;

  static Future<List<Order>> getOrderList() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getorders.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    
    List res = jsonDecode(response.body);
    order_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        Order order = Order.fromJson(res[i]);
        order_list.add(order);
      }
    }
    return order_list;
  }

  static Future<OrderDetail> getOrderDetail(int id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "id" : id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getorderdetails.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode == 200){
      var res = jsonDecode(response.body);
      order_detail = OrderDetail.fromJson(res);
    }
    return order_detail;
  }

  static Future<dynamic> getLastOrders() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getlastorder.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    
    List res = jsonDecode(response.body);
    if(res.length > 0){
      return res[0];
    }
    return null;
  }
}