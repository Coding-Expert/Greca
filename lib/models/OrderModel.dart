
class Order{

  int order_type;
  int id_port_order;
  int id_order;
  int order_status;
  int id_client;
  String travel_date;
  int id_port_from;
  int id_port_to;
  int id_route;
  int id_interim_route;
  String  route_name;
  String  company;
  int  id_company;
  String  departure;
  String  arrival;
  String  description;
  String  price;
  String  truck;
  int  id_truck;
  int  feature;
  String  driver;
  int  id_driver;
  String codriver;
  int  id_codriver;
  int  loaded;
  int  reefer;
  String  cargo;
  String  comments;
  String  cellphone;
  String  email;
  int  send_email;
  String  booking_code;
  int  single_service;
  int  single_service_type;
  String insert_date;
  String  update_date;

  Order({
    this.order_type,
    this.id_port_order,
    this.id_order,
    this.order_status,
    this.arrival,
    this.company,
    this.departure,
    this.description,
    this.price,
    this.route_name,
    this.booking_code,
    this.cargo,
    this.cellphone,
    this.codriver,
    this.comments,
    this.driver,
    this.email,
    this.feature,
    this.id_client,
    this.id_codriver,
    this.id_company,
    this.id_driver,
    this.id_interim_route,
    this.id_port_from,
    this.id_port_to,
    this.id_route,
    this.id_truck,
    this.insert_date,
    this.loaded,
    this.reefer,
    this.send_email,
    this.single_service,
    this.single_service_type,
    this.travel_date,
    this.truck,
    this.update_date
    
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    order_type: json["order_type"],
    id_port_order : json["id_port_order"],
    id_order : json["id_order"],
    order_status: json["order_status"],
    arrival : json["arrival"],
    company : json["company"],
    departure : json["departure"],
    description : json["desparture"],
    price : json["price"],
    route_name : json["route_name"],
    booking_code : json["booking_code"],
    cargo : json["cargo"],
    cellphone : json["cellphone"],
    codriver : json["codriver"],
    comments : json["comments"],
    driver: json["driver"],
    email : json["email"],
    feature : json["feature"],
    id_client : json["id_client"],
    id_codriver : json["id_codriver"],
    id_company : json["id_company"],
    id_driver : json["id_driver"],
    id_interim_route : json["id_interim_route"],
    id_port_from : json["id_port_from"],
    id_port_to : json["id_port_to"],
    id_route : json["id_route"],
    id_truck : json["id_truck"],
    insert_date : json["insert_date"],
    loaded : json["loaded"],
    reefer : json["reefer"],
    send_email : json["send_email"],
    single_service : json["single_service"],
    single_service_type : json["single_service_type"],
    travel_date : json["travel_date"],
    truck : json["truck"],
    update_date : json["update_date"]
    
  );
}