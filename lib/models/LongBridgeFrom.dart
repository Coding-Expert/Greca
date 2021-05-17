

class LongBridgeFrom {
  
  int port_id;
  String name;
  int country_id;
  String country;
  String flag;

  LongBridgeFrom({
    this.port_id,
    this.name,
    this.country_id,
    this.country,
    this.flag
  });

  factory LongBridgeFrom.fromJson(Map<String, dynamic> json) => LongBridgeFrom(
    port_id : json["port_id"],
    name: json["name"],
    country_id: json["country_id"],
    country: json["country"],
    flag: json["flag"]
    
  );
}