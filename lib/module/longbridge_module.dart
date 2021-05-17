
import 'package:greca/models/LongBridgeFrom.dart';
import 'package:greca/models/LongBridgeRoute.dart';
import 'package:greca/models/LongBridgeTo.dart';
import 'package:greca/models/SubRoute.dart';
import 'package:greca/module/user_module.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LongBridgeModule {

  static List<LongBridgeFrom> from_list = [];
  static List<LongBridgeTo> to_list = [];
  static List<LongBridgeRoute> route_list = [];
  static List<SubRoute> sub_route_list = [];


  static Future<List<LongBridgeFrom>> getLongBridgeFrom() async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/longbridge/getports.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    from_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        from_list.add(LongBridgeFrom.fromJson(res[i]));
      }
    }
    
    return from_list;
  }

  static Future<List<LongBridgeTo>> getLongBridgeTo(int id) async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "id": id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/longbridge/getportdestinations.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    to_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        to_list.add(LongBridgeTo.fromJson(res[i]));
      }
    }
    
    return to_list;
  }

  static Future<List<LongBridgeRoute>> getLongBridgeRoutes(int departure, int arrival, String date1, String date2, int featureId) async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": departure,
      "arrival": arrival,
      "traveldate": date1,
      "traveldate2": date2,
      "feature": featureId
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/longbridge/getroutes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    route_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        List routes = res[i]["routes"];
        sub_route_list = [];
        if(routes.length > 0){
          for(int j = 0; j < routes.length; j++){
            var sub_route = SubRoute(
              id_port_from: routes[j]["id_port_from"],
              id_port_to: routes[j]["id_port_to"],
              id_route: routes[j]["id_route"],
              id_interim_route: routes[j]["id_interim_route"],
              route_name: routes[j]["route_name"],
              id_company: routes[j]["id_company"],
              company: routes[j]["company"],
              departure: routes[j]["departure"],
              arrival: routes[j]["arrival"],
              description: routes[j]["description"],
              price: routes[j]["price"]
            );
            sub_route_list.add(sub_route);
          }
        }
        
        var longbrige_route = LongBridgeRoute(
          id_port_from: res[i]["id_port_from"],
          id_port_to: res[i]["id_port_to"],
          id_route: res[i]["id_route"],
          id_interim_route: res[i]["id_interim_route"],
          route_name: res[i]["route_name"],
          id_company: res[i]["id_company"],
          company: res[i]["company"],
          departure: res[i]["departure"],
          arrival: res[i]["arrival"],
          description: res[i]["description"],
          price: res[i]["price"],
          routes: sub_route_list
        );
        route_list.add(longbrige_route);
      }
    }
    print("----longbridge route_length:${route_list.length}");
    return route_list;
  }
}