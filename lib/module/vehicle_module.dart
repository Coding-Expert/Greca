import 'package:greca/models/RegistNum.dart';
import 'package:greca/models/VehicleClassType.dart';
import 'package:greca/models/VehicleEuroType.dart';
import 'package:greca/models/VehicleLength.dart';
import 'package:greca/models/VehicleType.dart';

import 'region_train.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:greca/module/user_module.dart';

class VehicleModule {
  static List<VehicleLength> vehLength_list;
  static List<VehicleType> vehType_list;
  static List<RegistNum> regnum_list;
  static List<VehicleClassType> class_list;
  static List<VehicleEuroType> eurotype_list;
  

  static Future getVeh_Length() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/gettruckfeatures.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    vehLength_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var veh_length = VehicleLength(
          truck_feature_id: res[i]["truck_feature_id"],
          truck_feature_category: res[i]["truck_feature_category"],
          
        );
        vehLength_list.add(veh_length);
      }
    }
  }

  static Future getVeh_Type() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/gettrucktypes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    vehType_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var veh_type = VehicleType(
          type: res[i]["truck_type_id"],
          name: res[i]["truck_type_name"],
          
        );
        vehType_list.add(veh_type);
      }
    }
  }

  static Future getVeh_RegNum() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/client/gettrucks.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    regnum_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var reg_num = RegistNum(
          truck_id: res[i]["truck_id"],
          truck_num: res[i]["truck_num"],
          
        );
        regnum_list.add(reg_num);
      }
    }
  }

  static Future<Map<String, dynamic>> changeTruckInfo(String user_sessId, String truck_num) async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
      "truck_num" : "${truck_num}"
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/client/gettruck.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    var res = jsonDecode(response.body);
    return res;
  }
  static Future<List<VehicleClassType>> getVehicleClassType() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getvehicletypes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    class_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var veh_classType = VehicleClassType(
          vehicle_type_id: res[i]["vehicle_type_id"],
          vehicle_type_name: res[i]["vehicle_type_name"],
          
        );
        class_list.add(veh_classType);
      }
      var veh_classType = VehicleClassType(
        vehicle_type_id: 8,
        vehicle_type_name : "Other"
      );
      class_list.add(veh_classType);
    }
  }

  static Future getEuroType() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/geteurotypes.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    List res = jsonDecode(response.body);
    eurotype_list = [];
    if(res.length > 0){
      for(int i = 0; i < res.length; i++){
        var veh_euroType = VehicleEuroType(
          vehicle_euro_type_id: res[i]["vehicle_euro_type_id"],
          vehicle_euro_type_name: res[i]["vehicle_euro_type_name"],
          
        );
        eurotype_list.add(veh_euroType);
      }
      var veh_euroType = VehicleEuroType(
        vehicle_euro_type_id: 8,
        vehicle_euro_type_name : "Other"
      );
      eurotype_list.add(veh_euroType);
    }
    print("-----euro type:${response.body}");
  }
  
}