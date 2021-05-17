
import 'dart:convert';
import 'package:greca/module/user_module.dart';
import 'package:http/http.dart' as http;
import 'package:greca/models/MessinaRoute.dart';

class EnglishMessinaModule {

  static List<MessinaRoute> english_messina_list = [];

  static Future<List<MessinaRoute>> getEnglishRoute(int departure, int arrival, String traveldate, int feature_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": departure,
      "arrival": arrival,
      "traveldate": traveldate,
      "feature": feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/channel/getferryroutes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    english_messina_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        english_messina_list.add(MessinaRoute.fromJson(res[i]));
      }
    }
    return english_messina_list;
  }
  static Future<List<MessinaRoute>> getMessinaRoute(int departure, int arrival, String traveldate, int feature_id) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": departure,
      "arrival": arrival,
      "traveldate": traveldate,
      "feature": feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/channel/getferryroutes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    english_messina_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        english_messina_list.add(MessinaRoute.fromJson(res[i]));
      }
    }
    return english_messina_list;
  }
}