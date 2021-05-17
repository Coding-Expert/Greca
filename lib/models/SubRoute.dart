

class SubRoute {

  int id_port_from;
  int id_port_to;
  int id_route;
  int id_interim_route;
  String route_name;
  int id_company;
  String company;
  String departure;
  String arrival;
  String description;
  String price;

  SubRoute({
    this.id_port_from,
    this.id_port_to,
    this.id_route,
    this.id_interim_route,
    this.route_name,
    this.id_company,
    this.company,
    this.departure,
    this.arrival,
    this.description,
    this.price,
  });
}