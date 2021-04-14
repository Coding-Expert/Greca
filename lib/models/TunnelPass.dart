import 'package:flutter/material.dart';

class TunnelPass {

  String selectedTunnel;
  String selectedRoute;
  String crossDate;
  String registrationNumber;
  String selectedVeh_length;
  String selectedVeh_type;
  String selectedVeh_class_type;
  String selectedEuro_vehicle;
  String notes;

  TunnelPass({
    this.selectedTunnel,
    this.selectedRoute,
    this.crossDate,
    this.registrationNumber,
    this.selectedVeh_length,
    this.selectedVeh_type,
    this.selectedVeh_class_type,
    this.selectedEuro_vehicle,
    this.notes
  }
  );

  Map<String, dynamic> toJson() => {
    "tunnel" : selectedTunnel,
    "route" : selectedRoute,
    "crossdate" : crossDate,
    "reg_number" : registrationNumber,
    "veh_length" : selectedVeh_length,
    "veh_type" : selectedVeh_type,
    "veh_class_type" : selectedVeh_class_type,
    "euro_vehicle" : selectedEuro_vehicle,
    "notes" : notes
  };

}