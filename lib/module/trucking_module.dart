

import 'package:greca/models/TruckingService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:greca/module/user_module.dart';

class TruckingModule {
  static List<TruckingService> trucking_list = [];

  static Future<List<TruckingService>> getTruckingService() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/trucking/gettruckingservices.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    List res = jsonDecode(response.body);
    trucking_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var trucking_service = TruckingService(
          trucking_type_id: res[i]["trucking_type_id"],
          name: res[i]["name"],
        );
        trucking_list.add(trucking_service);
      }
    }
    var trucking_service = TruckingService(
      trucking_type_id: -1,
      name: "other"
    );
    trucking_list.add(trucking_service);
    return trucking_list;
  }
  static Future<String> onBooking(int trucking_id, String trucking_other, String trucking_date, String from_location, String to_location, String notes, int order_id) async {
    String result = "";
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "trucking_id": trucking_id,
      "trucking_other": trucking_other,
      "traveldate": trucking_date,
      "from_location": from_location,
      "to_location": to_location,
      "notes": notes,
      "order_id": order_id
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/trucking/uploadbooking.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode == 200){
      result = "success";
    }
    return result;
  }
}