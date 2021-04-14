class BalanceModel {
  int id;
  String customer;
  String invoiceDate;
  int reportNumber;
  String departureDate;
  int refNumber;
  String company;
  String description;
  String truck;
  String route;
  int bookingCode;
  String debit;
  String credit;

  BalanceModel({this.id, this.customer, this.invoiceDate, this.reportNumber, this.departureDate, this.refNumber, this.company, this.description, this.truck,
  this.route, this.bookingCode, this.debit, this.credit});

  factory BalanceModel.fromJson(Map<String, dynamic> json){
    return BalanceModel(
      id: json['id'],
      customer: json['customer'],
      invoiceDate: json['invoiceDate'],
      reportNumber: json['reportNumber'],
      departureDate: json['departureDate'],
      refNumber: json['refNumber'],
      company: json['company'],
      description: json['description'],
      truck: json['truck'],
      route: json['route'],
      bookingCode: json['bookingCode'],
      debit: json['debit'],
      credit: json['credit'],
    );
  }

}