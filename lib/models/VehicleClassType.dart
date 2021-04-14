class VehicleClassType { 
  int vehicle_type_id;
  String vehicle_type_name;

  VehicleClassType({
    this.vehicle_type_id,
    this.vehicle_type_name
  });

  factory VehicleClassType.fromJson(Map<String, dynamic> json) => VehicleClassType(
    vehicle_type_id : json["vehicle_type_id"],
    vehicle_type_name: json["vehicle_type_name"],
  );
}