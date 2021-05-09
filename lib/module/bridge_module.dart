
import 'dart:convert';

import 'package:greca/models/Bridge.dart';
import 'package:greca/models/Country.dart';
import 'package:greca/models/VehicleManufactorer.dart';
import 'package:greca/module/user_module.dart';
import 'package:http/http.dart' as http;

class BridgeModule {
  static List<Bridge> bridge_list;
  static List<VehicleManufacturer> manufacturer_list;
  static List<Country> country_list;

  static Future getBridge() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/bridge/getbridges.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    bridge_list = [];
    print("bridge_length----:${res.length}");
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var bridge = Bridge(
          id_bridge: res[i]["id_bridge"],
          id_toll: res[i]["id_toll"],
          bridge_name: res[i]["bridge_name"],
          id_country_from: res[i]["id_country_from"],
          country_from: res[i]["country_from"],
          id_country_to: res[i]["id_country_to"],
          country_to: res[i]["country_to"],
          network_length: res[i]["network_length"],
          operators: res[i]["operators"],
          vehicles: res[i]["vehicles"]
        );
        bridge_list.add(bridge);
        
      }
      var bridge = Bridge(
        id_bridge: null,
        id_toll: null,
        bridge_name: "Other",
        id_country_from: null,
        country_from: null,
        id_country_to: null,
        country_to: null,
        network_length: null,
        operators: null,
        vehicles: null
      );
      bridge_list.add(bridge);
    }
    return bridge_list.length;
  }

  static Future<List<VehicleManufacturer>> getManufacturer() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getvehiclemanufacturers.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    manufacturer_list = [];
    print("manufaturer_length----:${res.length}");
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var manufacturer = VehicleManufacturer(
          vehicle_manufacturer_id: res[i]["vehicle_manufacturer_id"],
          vehicle_manufacturer_name: res[i]["vehicle_manufacturer_name"],
          
        );
        manufacturer_list.add(manufacturer);
      }
    }
    return manufacturer_list;
  }

  static Future<List<Country>> getCountry() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getvehiclecountries.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    country_list = [];
    print("manufaturer_length----:${res.length}");
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var country = Country(
          id_country: res[i]["id_country"],
          country_name: res[i]["country_name"],
          
        );
        country_list.add(country);
      }
    }
    return country_list;
  }

  static Future<int> onBooking(String data) async {
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/bridge/uploadbooking.php",
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if(response.statusCode == 200){
      print("------booking data${response.body}");
    }
    return response.statusCode;
  }
}