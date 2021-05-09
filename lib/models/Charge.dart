
import 'package:greca/models/ChargeInfo.dart';

class Charge {

  String updated_charges;
  double charges_total_debit;
  int charges_total_credit;
  double charges_total_amount;
  List<ChargeInfo> charge_info;

  Charge({
    this.charge_info,
    this.charges_total_amount,
    this.charges_total_credit,
    this.charges_total_debit,
    this.updated_charges
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
    charges_total_amount: json["charges_total_amount"],
    charges_total_credit: json["charges_total_credit"],
    charges_total_debit: json["charges_total_debit"],
    updated_charges : json["updated_charges"],
    charge_info: json["charge_info"]
  );
}