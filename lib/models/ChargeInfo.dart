

class ChargeInfo {

  String client;
  String ref_number;
  String trdate;
  String ddate;
  String report_number;
  String company;
  String description;
  String debit;
  String credit;
  String inv_filename;

  ChargeInfo({
    this.client,
    this.company,
    this.credit,
    this.ddate,
    this.debit,
    this.description,
    this.ref_number,
    this.report_number,
    this.trdate,
    this.inv_filename
  });

  factory ChargeInfo.fromJson(Map<String, dynamic> json) => ChargeInfo(
    client: json["client"],
    company: json["company"],
    credit: json["credit"],
    ddate : json["ddate"],
    debit: json["debit"],
    description : json["description"],
    ref_number : json["ref_number"],
    report_number : json["report_number"],
    trdate : json["trdate"],
    inv_filename: json["inv_filename"]
  );
}