

class FerryRegion {
  int region_id;
  String name;

  FerryRegion({
    this.region_id,
    this.name
  });

  factory FerryRegion.fromJson(Map<String, dynamic> json) => FerryRegion(
    region_id : json["region_id"],
    name: json["name"],
    
  );
}