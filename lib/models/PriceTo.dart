

class PriceTo {
  int id;
  String name;
  String country;

  PriceTo({
    this.id,
    this.name,
    this.country
  });

  factory PriceTo.fromJson(Map<String, dynamic> json) => PriceTo(
    id : json["id"],
    name: json["name"],
    country: json["country"],
   
  );
}