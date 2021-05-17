

class EnglishMessina {
  String route_name;
  int fromId;
  int toId;

  EnglishMessina({
    this.route_name,
    this.fromId,
    this.toId
  });

  factory EnglishMessina.fromJson(Map<String, dynamic> json) => EnglishMessina(
    route_name: json["route_name"],
    fromId: json["fromId"],
    toId: json["toId"],
    
  );
}