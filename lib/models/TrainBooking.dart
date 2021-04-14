
import 'package:greca/module/user_module.dart';

class TrainBooking{

  String region;
  String region1;
  String service_date;
  String registrationNumber;
  String selectedVeh_length;
  String selectedVeh_type;
  String length;
  String train_notes;

  TrainBooking({
    this.region,
    this.region1,
    this.service_date,
    this.registrationNumber,
    this.selectedVeh_length,
    this.selectedVeh_type,
    this.length,
    this.train_notes
  });

  Map<String, dynamic> toJson ()=> {
    "from" : region,
    "to" : region1,
    "date" : service_date,
    "reg_number" : registrationNumber,
    "veh_length": selectedVeh_length,
    "veh_type" : selectedVeh_type,
    "length" : length,
    "notes" : train_notes
  };
}