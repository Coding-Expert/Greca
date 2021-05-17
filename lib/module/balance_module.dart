
import 'dart:convert';

import 'package:greca/models/Charge.dart';
import 'package:greca/models/ChargeInfo.dart';
import 'package:greca/models/TransInfo.dart';
import 'package:greca/models/Transaction.dart';
import 'package:greca/module/user_module.dart';
import 'package:http/http.dart' as http;

class BalanceModule {
  static Transaction transaction;
  static List<Transaction> transaction_list = [];
  static List<TransInfo> transinfo_list = []; 
  static Charge charge;
  static List<ChargeInfo> charge_list = [];
  static List<String> year_list = [];

  static Future<List<Transaction>> getTransaction() async {
    var body = jsonEncode({
      "PHPSESSID": UserModule.user.sessId,
    });
    var response = await http.post(
      "https://www.greca.com.cy/b2b/app/getcharges.php",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode == 200){
      transaction_list = [];
      var res = jsonDecode(response.body);
      final decoded = jsonDecode(response.body) as Map;
      year_list = [];
      for(final year in decoded.keys){
        year_list.add(year.toString());
      }
      if(year_list.length > 0){
        for(int i = 0; i < year_list.length; i++){
          var data = res[year_list[i]];
          transinfo_list = [];
          List trans_array = data["transactions"];
          if(trans_array.length > 0){
            for(int j = 0; j < trans_array.length; j++){
              TransInfo trans_info = TransInfo.fromJson(trans_array[j]);
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
          transaction_list.add(transaction);
        }
      }
      // transinfo_list = [];
      // List charge_array = data["charges"];
      // if(charge_array.length > 0){
      //   for(int i = 0; i < charge_array.length; i++){
      //     ChargeInfo charge = ChargeInfo.fromJson(charge_array[i]);
      //     charge_list.add(charge);
      //   }
      // }
      // charge = Charge(
      //   updated_charges: data["updated_charges"],
      //   charges_total_amount: data["charges_total_amount"],
      //   charges_total_credit: data["charges_total_credit"],
      //   charges_total_debit: data["charges_total_debit"],
      //   charge_info: charge_list
      // );
    }
    return transaction_list;
  }

}