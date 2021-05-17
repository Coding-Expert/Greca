

class FerryRoute {
  
  int id_route;
  int id_interim_route;
  String route_name;
  int id_company;
  String company;
  String departure;
  String arrival;
  String description;
  String price;

  FerryRoute({
    this.id_route,
    this.id_interim_route,
    this.route_name,
    this.id_company,
    this.company,
    this.departure,
    this.arrival,
    this.description,
    this.price
  });

  factory FerryRoute.fromJson(Map<String, dynamic> json) => FerryRoute(
    id_route : json["id_route"],
    id_interim_route: json["id_interim_route"],
    route_name: json["route_name"],
    id_company: json["id_company"],
    company: json["company"],
    departure: json["departure"],
    arrival: json["arrival"],
    description: json["description"],
    price: json["price"]
    
  );

}