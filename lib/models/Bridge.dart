
class Bridge {
  int id_bridge; 
  int id_toll;
  String bridge_name;
  int id_country_from;
  String country_from;
  int id_country_to;
  String country_to;
  String network_length;
  String operators;
  String vehicles;

  Bridge({
    this.id_bridge,
    this.id_toll,
    this.bridge_name,
    this.id_country_from,
    this.country_from,
    this.id_country_to,
    this.country_to,
    this.network_length,
    this.operators,
    this.vehicles
  });

  factory Bridge.fromJson(Map<String, dynamic> json) => Bridge(
    id_bridge : json["id_bridge"],
    id_toll: json["id_toll"],
    bridge_name: json["bridge_name"],
    id_country_from: json["id_country_from"],
    country_from: json["country_from"],
    id_country_to: json["id_country_to"],
    country_to: json["country_to"],
    network_length: json["network_length"],
    operators: json["operators"],
    vehicles: json["vehicles"]
  );
}