class TruckRoute {
  int route_id;
  int inter_route_id;
  String route_name;
  int company_id;
  String company;
  String departure;
  String arrival;
  String description;
  String price;

  TruckRoute({
    this.route_id,
    this.inter_route_id,
    this.route_name,
    this.company_id,
    this.company,
    this.departure,
    this.arrival,
    this.description,
    this.price
  });

  factory TruckRoute.fromJson(Map<String, dynamic> json) => TruckRoute(
    route_id: json["route_id"],
    inter_route_id: json["interim_route_id"],
    route_name: json["route_name"],
    company_id: json["company_id"],
    company: json["company"],
    departure: json["departure"],
    arrival: json["arrival"],
    description: json["description"],
    price: json["price"]
  );
}