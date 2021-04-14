
class VehicleLength { 
  int truck_feature_id;
  String truck_feature_category;

  VehicleLength({
    this.truck_feature_id,
    this.truck_feature_category
  });

  factory VehicleLength.fromJson(Map<String, dynamic> json) => VehicleLength(
    truck_feature_id : json["truck_feature_id"],
    truck_feature_category: json["truck_feature_category"],
  );
}