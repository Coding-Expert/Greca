
class User {
  String lang;
  bool loggedIn;
  int id;
  String name;
  String email;
  String loggedDate;
  String sessId;
  bool isBroker;
  int brokerId;

  User({
    this.lang,
    this.loggedIn,
    this.id,
    this.name,
    this.email,
    this.loggedDate,
    this.sessId,
    this.isBroker,
    this.brokerId
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    lang: json["user_language"],
    loggedIn : json["loggedIn"],
    id : json["clientId"],
    name : json["clientName"],
    email : json["clientEmail"],
    loggedDate : json["loggedDate"],
    sessId : json["PHPSESSID"],
    isBroker : json["isBroker"],
    brokerId : json["brokerId"]
  );

  Map<String, dynamic> toJson()=> {
    "lang" : lang,
    "loggedIn" : loggedIn,
    "id" : id,
    "name" : name,
    "email" : email,
    "loggedDate" : loggedDate,
    "sessId" : sessId,
    "isBroker" : isBroker,
    "brokerId" : brokerId
  };
}