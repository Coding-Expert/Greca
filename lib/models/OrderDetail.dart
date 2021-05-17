
class OrderDetail {

  int id_port_order;
  int id_order;
  int order_status;
  int id_client;
  String travel_date;
  int id_port_from;
  String port_from;
  String country_from;
  int id_port_to;
  String port_to;
  String country_to;
  int id_route;
  int id_interim_route;
  String route_name;
  String company;
  int id_company;
  String departure;
  String arrival;
  String description;
  String price;
  String truck;
  int id_truck;
  int id_feature;
  String feature_category;
  int id_truck_type;
  String truck_type;
  String trailer;
  int id_trailer;
  int id_trailer_feature;
  String trailer_feature_category;
  int id_trailer_type;
  String trailer_type;
  String driver;
  int id_driver;
  int codriver;
  int id_codriver;
  int loaded;
  String cargo;
  String animals;
  int hazardous;
  String adr_description;
  String adr_class;
  int adr_un_number;
  String adr_packing_group;
  int reefer;
  int temperature;
  int single_service;
  int single_service_type;
  String comments;
  String cellphone;
  String email;
  int send_email;
  String booking_code;
  int is_longbridge;
  int longbridge_order_id;
  String insert_date;
  String update_date;
  int from_booking;
  // List<Detail> detail_list;

  OrderDetail({
    this.arrival,
    this.booking_code,
    this.cargo,
    this.cellphone,
    this.codriver,
    this.comments,
    this.company,
    this.country_from,
    this.country_to,
    this.departure,
    this.description,
    this.driver,
    this.email,
    this.id_client,
    this.id_codriver,
    this.id_company,
    this.id_driver,
    this.id_interim_route,
    this.id_order,
    this.id_port_from,
    this.id_port_order,
    this.id_port_to,
    this.id_route,
    this.id_truck,
    this.insert_date,
    this.loaded,
    this.order_status,
    this.price,
    this.reefer,
    this.route_name,
    this.send_email,
    this.single_service,
    this.single_service_type,
    this.travel_date,
    this.truck,
    this.update_date,
    this.adr_class,
    this.adr_description,
    this.adr_packing_group,
    this.adr_un_number,
    this.animals,
    // this.detail_list,
    this.feature_category,
    this.from_booking,
    this.hazardous,
    this.id_feature,
    this.id_trailer,
    this.id_trailer_feature,
    this.id_trailer_type,
    this.id_truck_type,
    this.is_longbridge,
    this.longbridge_order_id,
    this.port_from,
    this.port_to,
    this.temperature,
    this.trailer,
    this.trailer_feature_category,
    this.trailer_type,
    this.truck_type,
    
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    arrival : json["arrival"],
    booking_code : json["booking_code"],
    cargo : json["cargo"],
    cellphone : json["cellphone"],
    codriver : json["codriver"],
    comments : json["comments"],
    company : json["company"],
    country_from : json["country_from"],
    country_to : json["country_to"],
    departure : json["departure"],
    description : json["description"],
    driver : json["driver"],
    email : json["email"],
    id_client : json["id_client"],
    id_codriver : json["id_codriver"],
    id_company : json["id_company"],
    id_driver : json["id_driver"],
    id_interim_route : json["id_interim_route"],
    id_order : json["id_order"],
    id_port_from : json["id_port_from"],
    id_port_order : json["id_port_order"],
    id_port_to : json["id_port_to"],
    id_route : json["id_route"],
    id_truck : json["id_truck"],
    insert_date : json["insert_date"],
    loaded : json["loaded"],
    order_status : json["order_status"],
    price : json["price"],
    reefer : json["reefer"],
    route_name : json["route_name"],
    send_email : json["send_email"],
    single_service : json["single_service"],
    single_service_type : json["single_service_type"],
    travel_date : json["travel_date"] != null ? json["travel_date"] : "",
    truck : json["truck"],
    update_date : json["update_date"],
    adr_class : json["adr_class"],
    adr_description : json["adr_description"],
    adr_packing_group : json["adr_packing_group"],
    adr_un_number : json["adr_un_number"],
    animals : json["animals"],
    // detail_list : json["detail_list"],
    feature_category : json["feature_category"],
    from_booking : json["from_booking"],
    hazardous : json["hazardous"],
    id_feature : json["id_feature"],
    id_trailer : json["id_trailer"],
    id_trailer_feature : json["id_trailer_feature"],
    id_trailer_type : json["id_trailer_type"],
    id_truck_type : json["id_truck_type"],
    is_longbridge : json["is_longbridge"],
    longbridge_order_id : json["longbridge_order_id"],
    port_from : json["port_from"],
    port_to : json["port_to"],
    temperature : json[""],
    trailer : json["temperature"],
    trailer_feature_category : json["trailer_feature_category"],
    trailer_type : json["trailer_type"],
    truck_type : json["truck_type"],
  );
}