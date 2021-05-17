
import 'package:greca/models/FerryFrom.dart';
import 'package:greca/models/FerryRegion.dart';
import 'package:greca/models/FerryRoute.dart';
import 'package:greca/models/FerryTo.dart';
import 'package:greca/module/user_module.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FerryModule {
  static List<FerryRegion> ferry_region_list = [];
  static List<FerryFrom> ferry_from_list = [];
  static List<FerryTo> ferry_to_list = [];
  static List<FerryRoute> ferry_route_list = [];

  static Future<List<FerryRegion>> getFerryRegion() async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/ferry/getregions.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    ferry_region_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var region = FerryRegion(
          region_id: res[i]["region_id"],
          name: res[i]["name"],
        );
        ferry_region_list.add(region);
      }
    }
    
    return ferry_region_list;
  }

  static Future<List<FerryFrom>> getFerryFrom(int region_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "id": region_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/ferry/getregionports.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    ferry_from_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        
        ferry_from_list.add(FerryFrom.fromJson(res[i]));
      }
    }
    
    return ferry_from_list;
  }

  static Future<List<FerryTo>> getFerryTo(int region_id, int from_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "region": region_id,
      "id": from_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/ferry/getportdestinations.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    ferry_to_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        ferry_to_list.add(FerryTo.fromJson(res[i]));
      }
    }
    return ferry_to_list;
  }

  static Future<List<FerryRoute>> getFerryRoute(int departure, int arrival, String traveldate, int feature_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": departure,
      "arrival": arrival,
      "traveldate": traveldate,
      "feature": feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/ferry/getferryroutes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    ferry_route_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        ferry_route_list.add(FerryRoute.fromJson(res[i]));
      }
    }
    return ferry_route_list;
  }
}