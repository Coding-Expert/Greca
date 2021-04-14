
class VehicleType {
  int type;
  String name;

  VehicleType({
    this.type,
    this.name
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    type : json["truck_id"],
    name: json["truck_num"],
  );
}