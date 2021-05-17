
import 'package:greca/models/PriceFrom.dart';
import 'package:greca/models/PriceTo.dart';
import 'package:greca/models/Prices.dart';
import 'package:greca/module/user_module.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PriceModule {

  static List<PriceFrom> from_list = [];
  static List<PriceTo> to_list = [];
  static List<Prices> specific_price_list = [];
  static List<Prices> price_list = [];

  static Future<List<PriceFrom>> getFromList() async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getpriceports.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    from_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        from_list.add(PriceFrom.fromJson(res[i]));
      }
    }
    return from_list;
  }

  static Future<List<PriceTo>> getToList(int id) async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "id": id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getpricedestinations.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    to_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        to_list.add(PriceTo.fromJson(res[i]));
      }
    }
    return to_list;
  }

  static Future<List<Prices>> specificPriceList(int from_id, int to_id, String date, int feature_id) async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": from_id,
      "arrival": to_id,
      "traveldate": date,
      "feature": feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getpricelist.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var data = jsonDecode(response.body);
    
    List res = data["records"];
    specific_price_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        specific_price_list.add(Prices.fromJson(res[i]));
      }
    }
    print("----price count:${specific_price_list.length}");
    return specific_price_list;
  }

  static Future<List<Prices>> priceList(int from_id, int to_id, int feature_id) async {

    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "departure": from_id,
      "arrival": to_id,
      "feature": feature_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getpricelist.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var data = jsonDecode(response.body);
    
    List res = data["records"];
    price_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        price_list.add(Prices.fromJson(res[i]));
      }
    }
    print("----price count:${price_list.length}");
    return price_list;
  }
}