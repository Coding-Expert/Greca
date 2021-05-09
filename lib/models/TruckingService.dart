
class TruckingService {
  int trucking_type_id;
  String name;

  TruckingService({
    this.trucking_type_id,
    this.name
  });

  factory TruckingService.fromJson(Map<String, dynamic> json) => TruckingService(
    trucking_type_id : json["trucking_type_id"],
    name: json["name"],
    
  );
}