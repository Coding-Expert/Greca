
class EuroTunnel {
  String selectedEuroRoute;
  String euro_cross_date;
  String euro_tunnel_number;
  String selectedVeh_length;
  String selectedVeh_type;
  String euro_tunnel_meter;
  String euro_notes;

  EuroTunnel({
    this.selectedEuroRoute,
    this.euro_cross_date,
    this.euro_tunnel_number,
    this.selectedVeh_length,
    this.selectedVeh_type,
    this.euro_tunnel_meter,
    this.euro_notes,
  });

  Map<String, dynamic> toJson() => {
    "route" : selectedEuroRoute,
    "crossdate" : euro_cross_date,
    "reg_number" : euro_tunnel_number,
    "veh_length" : selectedVeh_length,
    "veh_type" : selectedVeh_type,
    "euro_tunnel_meter" : euro_tunnel_meter,
    "euro_notes" : euro_notes
  };
}