
import 'dart:convert';

import 'package:greca/models/Charge.dart';
import 'package:greca/models/ChargeInfo.dart';
import 'package:greca/models/TransInfo.dart';
import 'package:greca/models/Transaction.dart';
import 'package:greca/module/user_module.dart';
import 'package:http/http.dart' as http;

class BalanceModule {
  static Transaction transaction;
  static List<TransInfo> transinfo_list = []; 
  static Charge charge;
  static List<ChargeInfo> charge_list = [];

  static Future<Transaction> getTransaction() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getcharges.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode == 200){
      
      var res = jsonDecode(response.body);
      var data = res["2020"];
      transinfo_list = [];
      List trans_array = data["transactions"];
      if(trans_array.length > 0){
        for(int i = 0; i < trans_array.length; i++){
          TransInfo trans_info = TransInfo.fromJson(trans_array[i]);
          transinfo_list.add(trans_info);
        }
      }
      
      transaction = Transaction(
        updated_transactions: data["updated_transactions"],
        transactions_total_debit: data["transactions_total_debit"],
        transactions_total_amount: data["transactions_total_amount"],
        transactions_total_credit: data["transactions_total_credit"],
        trans_info: transinfo_list
      );
      transinfo_list = [];
      List charge_array = data["charges"];
      if(charge_array.length > 0){
        for(int i = 0; i < charge_array.length; i++){
          ChargeInfo charge = ChargeInfo.fromJson(charge_array[i]);
          charge_list.add(charge);
        }
      }
      print("---transInfo:${charge_list.length}");
      charge = Charge(
        updated_charges: data["updated_charges"],
        charges_total_amount: data["charges_total_amount"],
        charges_total_credit: data["charges_total_credit"],
        charges_total_debit: data["charges_total_debit"],
        charge_info: charge_list
      );
    }
    return transaction;
  }

}