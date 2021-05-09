import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class TunnelModule {

  static Future<int> onBooking(String data) async {
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/tunnel/uploadbooking.php",
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if(response.statusCode == 200){
      print("------booking data${response.body}");
    }
    return response.statusCode;
  }

}