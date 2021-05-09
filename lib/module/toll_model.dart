
import 'package:greca/models/TollModel.dart';
import 'region_train.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:greca/module/user_module.dart';

class TollModule {

  static List<TollModel> toll_list = [];

  static Future<List<TollModel>> getCountry() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/toll/gettollcountries.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    
    List res = jsonDecode(response.body);
    toll_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var from = TollModel(
          country_id: res[i]["country_id"],
          name: res[i]["name"],
          flag: res[i]["flag"],
          status: false
        );
        toll_list.add(from);
      }
    }
    return toll_list;
  }

  static Future<String> onBooking(List<Map<String, dynamic>> data) async {
    String entry_id = "";
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "countries" : data
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/toll/uploadbooking.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      entry_id = data["id_toll_order"];
    }
    print("---result:${response.body.toString()}");
    return entry_id;
  }
}