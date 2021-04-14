
class Country {
  int id_country;
  String country_name;

  Country({
    this.id_country,
    this.country_name
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id_country : json["id_country"],
    country_name: json["country_name"],
    
  );
}