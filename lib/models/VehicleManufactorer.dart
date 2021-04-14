
class VehicleManufacturer {
  int vehicle_manufacturer_id;
  String vehicle_manufacturer_name;

  VehicleManufacturer({
    this.vehicle_manufacturer_id,
    this.vehicle_manufacturer_name
  });

  factory VehicleManufacturer.fromJson(Map<String, dynamic> json) => VehicleManufacturer(
    vehicle_manufacturer_id : json["vehicle_manufacturer_id"],
    vehicle_manufacturer_name: json["vehicle_manufacturer_name"],
    
  );
}