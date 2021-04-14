
class RegionTrain {
  
  int port_id;
  String port_name;
  int country_id;
  String country_name;

  RegionTrain({
    this.port_id,
    this.port_name,
    this.country_id,
    this.country_name
  });

  factory RegionTrain.fromJson(Map<String, dynamic> json) => RegionTrain(
    port_id : json["port_id"],
    port_name: json["port_name"],
    country_id: json["country_id"],
    country_name: json["country_name"]
  );

  Map<String, dynamic> toJson() => {
    "port_id" : port_id,
    "port_name" : port_name,
    "country_id" : country_id,
    "country_name" : country_name
  };
}