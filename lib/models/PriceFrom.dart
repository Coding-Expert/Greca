
class PriceFrom {
  int port_id;
  int country_id;
  String country_name;
  String port_name;

  PriceFrom({
    this.port_id,
    this.country_id,
    this.country_name,
    this.port_name
  });

  factory PriceFrom.fromJson(Map<String, dynamic> json) => PriceFrom(
    port_id : json["port_id"],
    country_id: json["country_id"],
    country_name: json["country_name"],
    port_name: json["port_name"],
   
  );
}