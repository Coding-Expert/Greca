class RegistNum {
  int truck_id;
  String truck_num;

  RegistNum({
    this.truck_id,
    this.truck_num
  });

  factory RegistNum.fromJson(Map<String, dynamic> json) => RegistNum(
    truck_id : json["truck_type_id"],
    truck_num: json["truck_type_name"],
  );
}