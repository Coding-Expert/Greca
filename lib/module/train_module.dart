

import 'package:greca/models/Routes.dart';

import 'region_train.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:greca/module/user_module.dart';

class TrainModule {
  static List<RegionTrain> froms;
  static List<RegionTrain> tos;
  static List<TruckRoute> route_list;

  static Future getFrom() async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/train/getdeparturestations.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    
    List res = jsonDecode(response.body);
    froms = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var from = RegionTrain(
        port_id: res[i]["port_id"],
          port_name: res[i]["port_name"],
          country_id: res[i]["country_id"],
          country_name: res[i]["country_name"]
        );
        froms.add(from);
      }
    }
  }

  static Future getTo(int port_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "port_id" : port_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/train/getarrivalstations.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    tos = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var to = RegionTrain(
          port_id: res[i]["port_id"],
          port_name: res[i]["port_name"],
          country_id: res[i]["country_id"],
          country_name: res[i]["country_name"]
        );
        tos.add(to);
      }
    }
  }

  static Future<int> getRoutes(int port_id_from, int port_id_to, String date, int truck_feature_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "port_id_from" : port_id_from,
      "port_id_to" : port_id_to,
      "date_of_service" : date,
      "truck_feature_id" : truck_feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/train/getroutes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    route_list = [];
    print("route_length----:${res.length}");
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var route = TruckRoute(
          route_id: res[i]["route_id"],
          inter_route_id: res[i]["interim_route_id"],
          route_name: res[i]["route_name"],
          company_id: res[i]["company_id"],
          company: res[i]["company"],
          departure: res[i]["departure"],
          arrival: res[i]["arrival"],
          description: res[i]["description"],
          price: res[i]["price"]
        );
        route_list.add(route);
        
      }
    }
    return route_list.length;
  }
  static Future<int> onBooking(String data) async {
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/train/uploadbooking.php",
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if(response.statusCode == 200){
      print("------booking data${response.body}");
    }
    return response.statusCode;
  }
}