class VehicleEuroType { 
  int vehicle_euro_type_id;
  String vehicle_euro_type_name;

  VehicleEuroType({
    this.vehicle_euro_type_id,
    this.vehicle_euro_type_name
  });

  factory VehicleEuroType.fromJson(Map<String, dynamic> json) => VehicleEuroType(
    vehicle_euro_type_id : json["vehicle_euro_type_id"],
    vehicle_euro_type_name: json["vehicle_euro_type_name"],
  );
}