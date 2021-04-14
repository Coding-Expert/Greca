
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greca/models/Routes.dart';
import 'package:greca/module/user_module.dart';

class EuroModule {
  static List<TruckRoute> route_list;

  static Future<int> getRoutes(int port_id_from, int port_id_to, String date, int truck_feature_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "port_id_from" : port_id_from,
      "port_id_to" : port_id_to,
      "date_of_service" : date,
      "truck_feature_id" : truck_feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/eurotunnel/getroutes.php",
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
}