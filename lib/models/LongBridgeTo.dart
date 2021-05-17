
class LongBridgeTo {

  int id;
  String name;
  int id_country;
  String country;
  String country_flag;

  LongBridgeTo({
    this.id,
    this.name,
    this.id_country,
    this.country,
    this.country_flag
  });

  factory LongBridgeTo.fromJson(Map<String, dynamic> json) => LongBridgeTo(
    id : json["id"],
    name: json["name"],
    id_country: json["id_country"],
    country: json["country"],
    country_flag: json["country_flag"]
    
  );

}