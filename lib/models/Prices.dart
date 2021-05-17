

class Prices {
  int id_route;
  int id_intermediate_route;
  String company;
  String departure;
  String arrival;
  String description;
  String price;
  String day;

  Prices({
    this.id_route,
    this.id_intermediate_route,
    this.company,
    this.departure,
    this.arrival,
    this.description,
    this.price,
    this.day
  });

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
    id_route : json["id_route"],
    id_intermediate_route: json["id_intermediate_route"],
    company: json["company"],
    departure: json["departure"],
    arrival: json["arrival"],
    description: json["description"],
    price: json["price"],
    day: json["day"]
   
  );
}