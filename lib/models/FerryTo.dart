
class FerryTo {

  int id;
  String name;
  int id_country;
  String country;
  String country_flag;

  FerryTo({
    this.id,
    this.name,
    this.id_country,
    this.country,
    this.country_flag
  });

  factory FerryTo.fromJson(Map<String, dynamic> json) => FerryTo(
    id : json["id"],
    name: json["name"],
    id_country: json["id_country"],
    country: json["country"],
    country_flag: json["country_flag"]
    
  );

}