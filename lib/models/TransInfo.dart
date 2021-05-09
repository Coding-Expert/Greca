
class TransInfo {

  String client;
  String ref_number;
  String trdate;
  String ddate;
  String report_number;
  String company;
  String description;
  String truck;
  String route;
  String booking_code;
  String debit;
  String credit;
  String inv_filename;

  TransInfo(
    {
      this.truck,
      this.description,
      this.company,
      this.booking_code,
      this.client,
      this.credit,
      this.ddate,
      this.debit,
      this.ref_number,
      this.report_number,
      this.route,
      this.trdate,
      this.inv_filename
    }
  );

  factory TransInfo.fromJson(Map<String, dynamic> json) => TransInfo(
    truck : json["truck"],
    description : json["description"],
    company : json["company"],
    booking_code : json["booking_code"],
    client : json["client"],
    credit : json["credit"],
    ddate : json["ddate"],
    debit : json["debit"],
    ref_number : json["ref_number"],
    report_number : json["report_number"],
    route : json["route"],
    trdate : json["trdate"],
    inv_filename: json["inv_filename"]
  );
}