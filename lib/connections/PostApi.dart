import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class PostApi {
  String BASE_URL = "https://greca.com.cy/b2b/app";
  String TAG = "PostApi ===>";

  Future<String> login(String username, String password) async {
    var body = jsonEncode({
      "user": username,
      "pwd": password
    });
    print("$TAG URL: ${BASE_URL}/login.php");
    return await http.post("${BASE_URL}/login.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    ).then((http.Response response) {
      // print("$TAG Post Login: ${response.statusCode}");
      // print("$TAG Response Login: ${response.body}");
      if(response.statusCode==200){
        return response.body;
      }
      else{
        return "Unhandled Exception Login:\n${response.body}\n\n${response.headers}";
      }

    }).catchError((error, stackTrace){
      return "Unhandled Exception - catchError: ${BASE_URL}/api/Account/Login = ${error}";
    });
  }

}