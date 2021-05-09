class TollModel {
  int country_id;
  String name;
  String flag;
  bool status;

  TollModel({
    this.country_id,
    this.name,
    this.flag,
    this.status
  });

  factory TollModel.fromJson(Map<String, dynamic> json) => TollModel(
    country_id : json["country_id"],
    name: json["name"],
    flag: json["flag"]
    
  );

  Map<String, dynamic> toJson() => {
    "country_id": country_id,
    "name": name,
    "flag": flag,
    
  };
}