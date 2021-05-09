
import 'package:greca/models/TransInfo.dart';

class Transaction {

  String updated_transactions;
  double transactions_total_debit;
  double transactions_total_credit;
  double transactions_total_amount;
  List<TransInfo> trans_info;

  Transaction({
    this.trans_info,
    this.transactions_total_amount,
    this.transactions_total_credit,
    this.transactions_total_debit,
    this.updated_transactions
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    updated_transactions: json["updated_transactions"],
    transactions_total_amount: json["transactions_total_debit"],
    transactions_total_credit: json["transactions_total_credit"],
    transactions_total_debit : json["transactions_total_debit"],
    trans_info: json["trans_info"]
  );
}