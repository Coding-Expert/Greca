import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/style.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/MyStyle.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/models/Bridge.dart';
import 'package:greca/models/Country.dart';
import 'package:greca/models/EnglishMessina.dart';
import 'package:greca/models/EuroTunnel.dart';
import 'package:greca/models/FerryFrom.dart';
import 'package:greca/models/FerryRegion.dart';
import 'package:greca/models/FerryRoute.dart';
import 'package:greca/models/FerryTo.dart';
import 'package:greca/models/LongBridgeFrom.dart';
import 'package:greca/models/LongBridgeRoute.dart';
import 'package:greca/models/LongBridgeTo.dart';
import 'package:greca/models/MessinaRoute.dart';
import 'package:greca/models/OrderDetail.dart';
import 'package:greca/models/Routes.dart';
import 'package:greca/models/TempleteServiceModel.dart';
import 'package:greca/models/TollModel.dart';
import 'package:greca/models/TrainBooking.dart';
import 'package:greca/models/TruckingService.dart';
import 'package:greca/models/TunnelPass.dart';
import 'package:greca/models/VehicleClassType.dart';
import 'package:greca/models/VehicleEuroType.dart';
import 'package:greca/models/VehicleLength.dart';
import 'package:greca/models/VehicleManufactorer.dart';
import 'package:greca/module/bridge_module.dart';
import 'package:greca/module/english_messina_module.dart';
import 'package:greca/module/euro_module.dart';
import 'package:greca/module/ferry_module.dart';
import 'package:greca/module/longbridge_module.dart';
import 'package:greca/module/toll_model.dart';
import 'package:greca/module/train_module.dart';
import 'package:greca/module/trucking_module.dart';
import 'package:greca/module/tunnel_module.dart';
import 'package:greca/module/user_module.dart';
import 'package:greca/module/vehicle_module.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:toast/toast.dart';


class ServicesView extends StatefulWidget {
  int index;
  bool order;
  OrderDetail order_detail;

  ServicesView({
    this.index,
    this.order,
    this.order_detail
  });

  @override
  _ServicesViewState createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  String TAG = "ServicesView ===>";

  List<String> servicesName = [
    "FERRY SERVICES",
    "BRIDGE PASS",
    "TRAIN SERVICES",
    "TUNNEL PASS",
    "EUROTUNNEL PASS",
    "English | Messina",
    "ROAD TOLL",
    "BRIDGE PASS",
    "TRUCKING"
    ];

  bool _storebaeltBridge = false;
  bool _dartfordCrossing = false;

  List<TempleteServiceModel> listServiceModel = new List();

  TextEditingController inputDesc = new TextEditingController();

  bool isShowFormRegion = false;

  List<Region> _region = new List();
  final _json = JsonDecoder().convert('[{"label": "Choose", "value": "Denmark", "selected": true}, {"label": "Brenner, Italy", "value": "Brenner, Italy"},{"label": "Freiburg, Germany", "value":"Freiburg, Germany"},{"label": "Maribor, Slovenia", "value": "Maribor, Slovenia"},{"label": "Novara, Italy", "value":"Novara, Italy"},{"label":"Trento, Italy", "value":"Trento, Italy"},{"label":"Wells, Austria", "value": "Wells, Austria"},{"label":"Worgl, Austria", "value":"Worgl, Austria"}]');
  String selectedRegion;
  List<String> from_region = [];
  String selected_from;
  List<String> to_region = [];
  String selected_to;

  List<String> tunnels = ['Frezus Tunnel', 'Mont Black Tunnel'];
  String selectedTunnel;
  List<String> routes = ['IT-FR', 'FR-IT'];
  String selectedRoute;
  DateTime selectDate;
  String cross_date = "";
  String bridge_date = "";
  String service_date;
  TextEditingController number = TextEditingController(text: "");
  TextEditingController notes = TextEditingController(text: "");
  String error;
  List<String> vehicles_length = [];
  String selectedVeh_length;
  List<String> vehicles_type = [];
  String selectedVeh_type;
  List<VehicleClassType> vehicles_class_type = [];
  int tunnel_id = 0;
  VehicleClassType selectedVeh_class_type;
  List<String> euroclass_routes = ['EURO0','EURO1','EURO2','EURO3','EURO4','EURO5','EURO6','OTHER'];
  String selectedEuroClass;
  List<String> euroTunnel_routes = ['UK-FR', 'FR-UK'];
  List<Bridge> bridge_routes = [];
  Bridge selectedBridge;
  String selectedEuroRoute;
  String euro_cross_date = "";
  TextEditingController euro_tunnel_number = TextEditingController(text: "");
  TextEditingController euro_tunnel_meter = TextEditingController(text: "");
  TextEditingController euro_notes = TextEditingController(text: "");
  TextEditingController train_notes = TextEditingController(text: "");
  TextEditingController vehicle_manifacture = TextEditingController(text: "");
  TextEditingController vehicle_model = TextEditingController(text: "");
  TextEditingController vehicle_color = TextEditingController(text: "");
  TextEditingController bridge_number = TextEditingController(text: "");
  TextEditingController bridge_other = TextEditingController(text: "");
  TextEditingController vehicle_class_other = TextEditingController(text: "");
  TextEditingController vehicle_euro_class = TextEditingController(text: "");
  TextEditingController from_trucking = TextEditingController(text: "");
  TextEditingController to_trucking = TextEditingController(text: "");
  TextEditingController comment_trucking = TextEditingController(text: "");
  TextEditingController other_trucking = TextEditingController(text: "");
  TextEditingController euro_mrn = TextEditingController(text: "");
  TextEditingController euro_grm = TextEditingController(text: "");
  final ScrollController _scrollController = ScrollController();

  bool from_flag = false;
  bool to_flag = false;
  bool vehicles_length_flag = false;
  bool vehicle_type_flag = false;
  bool vehicle_regnum_flag = false;
  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController trailerController = TextEditingController();
  String _selectedCity;
  List<String> suggest_list;
  List<String> trailer_suggest_list;
  bool veh_length_state = true;
  bool veh_type_state = true;
  bool trailer_veh_length_state = true;
  bool trailer_veh_type_state = true;
  // ignore: non_constant_identifier_names
  List<TruckRoute> selected_route_list = [];
  String selected_truck_num;
  String selected_trailer_num;
  String trailer_selectedVeh_length;
  String trailer_selectedVeh_type;
  bool class_type_flag = false;
  bool euro_type_flag = false;
  List<VehicleEuroType> vehicles_euro_type = [];
  VehicleEuroType selectedEuro_veh_type;
  bool bridge_flag = false;
  bool manufacturer_flag = false;
  List<VehicleManufacturer> manufacturer_list = [];
  VehicleManufacturer selected_manufacturer;
  bool country_flag = false;
  List<Country> country_list = [];
  Country selected_country;
  int port_id_from = 0;
  int port_id_to = 0;
  int truck_feature_id = 0;
  int id_direction_from = 0;
  int id_direction_to = 0;
  List<TollModel> toll_list = [];
  bool toll_flag = false;
  List<TruckingService> trucking_list = [];
  bool trucking_loading = false;
  TruckingService selectedTruckingService;
  String trucking_date;
  List<FerryRegion> ferry_region_list = [];
  bool ferry_region_loading = false;
  FerryRegion selected_ferry_region;
  List<FerryFrom> ferry_from_list = [];
  bool ferry_from_loading = false;
  FerryFrom selected_ferry_from;
  List<FerryTo> ferry_to_list = [];
  bool ferry_to_loading = false;
  FerryTo selected_ferry_to;
  String ferry_date;
  List<FerryRoute> selected_ferry_route_list = [];
  bool empty_flag = false;
  String attach_file;
  String file_extension;
  String file_name;
  List<PlatformFile> mrn_files = [];
  List<PlatformFile> grm_files = [];
  String longbridge_date;
  bool longbridge_from_loading = false;
  List<LongBridgeFrom> longbridge_fromList = [];
  LongBridgeFrom selected_longbridge_from;
  bool longbridge_to_loading = false;
  List<LongBridgeTo> longbridge_toList = [];
  LongBridgeTo selected_longbridge_to;
  String longbridge_date1;
  String longbridge_date2;
  List<VehicleLength> long_bridge_vehicles_length = [];
  VehicleLength selected_longbridge_vehicleLength;
  List<LongBridgeRoute> selected_longbridgeroute_list = [];
  List<String> english_messina = [];
  String selected_english_messina;
  List<EnglishMessina> second_location_list = [];
  EnglishMessina selected_second_location;
  String enlgish_messina_date;
  List<MessinaRoute> selected_messina_route_list = [];

  @override
  void initState() {
    _region = (_json).map<Region>((item) => Region.fromJson(item)).toList();
    selectedRegion = _region[0].label;
    if(service_date == null){
      service_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    }
    trucking_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    ferry_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    cross_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    euro_cross_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    bridge_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    longbridge_date1 = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    longbridge_date2 = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    enlgish_messina_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();

    if(widget.index == 2){
      getTrainInfo();
    }
    if(widget.index == 3){
      getTunnelInfo();
    }
    if(widget.index == 4){
      getEuroTunnelInfo();
    }
    if(widget.index == 7){
      getBridgeInfo();
    }
    if(widget.index == 6){
      getTollInfo();
    }
    if(widget.index == 8){
      getTruckingService();
    }
    if(widget.index == 0){
      getFerryInfo();
    }
    if(widget.index == 1){
      getLongBridgeInfo();
    }
    if(widget.index == 5){
      getEnglishMessinaInfo();
    }
    // _typeAheadController.addListener(() {
    //   print("value------:${_typeAheadController.text}");
      
    // });
    super.initState();
    print("$TAG initState running...");
    //0=Ferry, 1=Lognbridge, 2=Train, 3=Tunnel, 4=Eurotunnel, 5=Trucking, 6=Toll
    print("$TAG Param index: ${widget.index}");
    print("$TAG Param index title: ${servicesName[widget.index]}");
    _setModel();
  }

  Future<void> getEnglishMessinaInfo() async {
    english_messina.add("English-channel");
    english_messina.add("Straits of Messina");

    await VehicleModule.getVeh_Length().then((value){
      setState(() {
        vehicles_length_flag = true;
        if(VehicleModule.vehLength_list.length > 0){
          for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
            vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
          }
        }
      });
    });
    await VehicleModule.getVeh_Type().then((value){
      setState(() {
        vehicle_type_flag = true;
        if(VehicleModule.vehType_list.length > 0){
          for(int i = 0; i < VehicleModule.vehType_list.length; i++){
            vehicles_type.add(VehicleModule.vehType_list[i].name);
          }
        }
      });
      
    });
    await VehicleModule.getVeh_RegNum().then((value){
      setState(() {
        vehicle_regnum_flag = true;
      });
    });
  }

  Future<void> getFerryInfo() async {
    ferry_region_loading = true;
    await FerryModule.getFerryRegion().then((value) {
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          ferry_region_list.add(value[i]);
        }
      }
      setState(() {
        ferry_region_loading = false;
      });
    });
    await VehicleModule.getVeh_Length().then((value){
      setState(() {
        vehicles_length_flag = true;
        if(VehicleModule.vehLength_list.length > 0){
          for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
            vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
          }
        }
      });
    });
    await VehicleModule.getVeh_Type().then((value){
      setState(() {
        vehicle_type_flag = true;
        if(VehicleModule.vehType_list.length > 0){
          for(int i = 0; i < VehicleModule.vehType_list.length; i++){
            vehicles_type.add(VehicleModule.vehType_list[i].name);
          }
        }
      });
      
    });
    await VehicleModule.getVeh_RegNum().then((value){
      setState(() {
        vehicle_regnum_flag = true;
      });
    });
  }

  Future<void> getLongBridgeInfo() async {
    longbridge_from_loading = true;
    await LongBridgeModule.getLongBridgeFrom().then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          longbridge_fromList.add(value[i]);
        }
      }
      setState(() {
        longbridge_from_loading = false;
      });
    });
    await VehicleModule.getVeh_Length().then((value){
      setState(() {
        vehicles_length_flag = true;
        if(VehicleModule.vehLength_list.length > 0){
          for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
            vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
          }
        }
      });
    });
    await VehicleModule.getVeh_Type().then((value){
      setState(() {
        vehicle_type_flag = true;
        if(VehicleModule.vehType_list.length > 0){
          for(int i = 0; i < VehicleModule.vehType_list.length; i++){
            vehicles_type.add(VehicleModule.vehType_list[i].name);
          }
        }
      });
      
    });
    await VehicleModule.getVeh_RegNum().then((value){
      setState(() {
        vehicle_regnum_flag = true;
      });
    });
  }

  Future<void> getLongBridgeTo(int id) async {
    longbridge_to_loading = true;
    longbridge_toList = [];
    await LongBridgeModule.getLongBridgeTo(id).then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          
          longbridge_toList.add(value[i]);
        }
      }
      setState(() {
        longbridge_to_loading = false;
      });
    });
  }

  Future<void> getTruckingService() async {
    trucking_loading = true;
    trucking_list = [];
    await TruckingModule.getTruckingService().then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          trucking_list.add(value[i]);
        }
      }
      setState(() {
        trucking_loading = false;
      });
    });
    
  }
  Future<void> getTrainInfo() async {
    await TrainModule.getFrom().then((value){
      setState(() {
        from_flag = true;
        if(TrainModule.froms.length > 0){
          for(int i = 0; i < TrainModule.froms.length; i++){
            from_region.add(TrainModule.froms[i].port_name + ", " + TrainModule.froms[i].country_name);
          }
        }
      });
    });
    await VehicleModule.getVeh_Length().then((value){
      setState(() {
        vehicles_length_flag = true;
        if(VehicleModule.vehLength_list.length > 0){
          for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
            vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
          }
        }
      });
    });
    await VehicleModule.getVeh_Type().then((value){
      setState(() {
        vehicle_type_flag = true;
        if(VehicleModule.vehType_list.length > 0){
          for(int i = 0; i < VehicleModule.vehType_list.length; i++){
            vehicles_type.add(VehicleModule.vehType_list[i].name);
          }
        }
      });
      
    });
    await VehicleModule.getVeh_RegNum().then((value){
      setState(() {
        vehicle_regnum_flag = true;
      });
    });
    
  }

  Future<void> getTunnelInfo() async {
    if(mounted){
      await VehicleModule.getVeh_Length().then((value){
        setState(() {
          vehicles_length_flag = true;
          if(VehicleModule.vehLength_list.length > 0){
            for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
              vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
            }
          }
          VehicleModule.getVehicleClassType().then((value){
            setState(() {
              class_type_flag = true;
              if(VehicleModule.class_list.length > 0){
                for(int i = 0; i < VehicleModule.class_list.length; i++){
                  vehicles_class_type.add(VehicleModule.class_list[i]);
                }
                selectedVeh_class_type = null;
              }
            });
          });
        });
      });
      await VehicleModule.getVeh_Type().then((value){
        setState(() {
          vehicle_type_flag = true;
          if(VehicleModule.vehType_list.length > 0){
            for(int i = 0; i < VehicleModule.vehType_list.length; i++){
              vehicles_type.add(VehicleModule.vehType_list[i].name);
            }
          }
        });
        
      });
      await VehicleModule.getVeh_RegNum().then((value){
        setState(() {
          vehicle_regnum_flag = true;
        });
      });
      await VehicleModule.getEuroType().then((value){
        setState(() {
          euro_type_flag = true;
          print("----euro type:${VehicleModule.eurotype_list.length}");
          if(VehicleModule.eurotype_list.length > 0){
            for(int i = 0; i < VehicleModule.eurotype_list.length; i++){
              vehicles_euro_type.add(VehicleModule.eurotype_list[i]);
            }
            selectedEuro_veh_type = null;
          }
        });
      });
    }
  }
  Future<void> getEuroTunnelInfo() async {
    if(mounted){
      await VehicleModule.getVeh_Length().then((value){
        setState(() {
          vehicles_length_flag = true;
          if(VehicleModule.vehLength_list.length > 0){
            for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
              vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
            }
          }
        });
      });
      VehicleModule.getVeh_Type().then((value){
        setState(() {
          vehicle_type_flag = true;
          if(VehicleModule.vehType_list.length > 0){
            for(int i = 0; i < VehicleModule.vehType_list.length; i++){
              vehicles_type.add(VehicleModule.vehType_list[i].name);
            }
          }
        });
        
      });
      await VehicleModule.getVeh_RegNum().then((value){
        setState(() {
          vehicle_regnum_flag = true;
        });
      });
    }
  }
  Future<void> getBridgeInfo() async {
    if(mounted){
      await BridgeModule.getBridge().then((value){
        setState(() {
          bridge_flag = true;
          if(BridgeModule.bridge_list.length > 0){
            for(int i = 0; i < BridgeModule.bridge_list.length; i++){
              bridge_routes.add(BridgeModule.bridge_list[i]);
            }
            selectedBridge = null;
          }
        });
      });
      await VehicleModule.getVeh_Length().then((value){
        setState(() {
          vehicles_length_flag = true;
          if(VehicleModule.vehLength_list.length > 0){
            for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
              vehicles_length.add(VehicleModule.vehLength_list[i].truck_feature_category);
            }
          }
        });
      });
      VehicleModule.getVeh_Type().then((value){
        setState(() {
          vehicle_type_flag = true;
          if(VehicleModule.vehType_list.length > 0){
            for(int i = 0; i < VehicleModule.vehType_list.length; i++){
              vehicles_type.add(VehicleModule.vehType_list[i].name);
            }
          }
        });
        
      });
      BridgeModule.getManufacturer().then((value){
        setState(() {
          manufacturer_flag = true;
          if(value.length > 0){
            for(int i = 0; i < value.length; i++){
              manufacturer_list.add(value[i]);
            }
          }
          selected_manufacturer = null;
        });
      });
      BridgeModule.getCountry().then((value){
        setState(() {
          country_flag = true;
          if(value.length > 0){
            for(int i = 0; i < value.length; i++){
              country_list.add(value[i]);
            }
          }
          selected_country = null;
        });
      });
    }
  }

  Future<void> getTollInfo() async {
    toll_flag = true;
    await TollModule.getCountry().then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          toll_list.add(value[i]);
        }
      }
      setState(() {
        toll_flag = false;
      });
    });
  }

  _setModel(){
    TempleteServiceModel value1 = new TempleteServiceModel();
    value1.index = widget.index;
    value1.title = servicesName[widget.index];
    String strImg = "";
    String strIcon = "";
    Color clrBg;
    if(widget.index==0){
      strImg = "assets/images/Ferry.jpg";
      strIcon = "assets/icons/01ferry.png";
      clrBg = Colors.blue;
    }
    if(widget.index==1){
      strImg = "assets/images/Bridge.jpg";
      strIcon = "assets/icons/05bridges.png";
      clrBg = Colors.deepPurple;
    }
    if(widget.index==2){
      strImg = "assets/images/Train.jpg";
      strIcon = "assets/icons/02train.png";
      clrBg = Colors.green;
    }
    if(widget.index==3){
      strImg = "assets/images/Tunnel.jpg";
      strIcon = "assets/icons/03tunnels.png";
      clrBg = Colors.red;
    }
    if(widget.index==4){
      strImg = "assets/images/Eurotunnel.jpg";
      strIcon = "assets/icons/04eurotunnel.png";
      clrBg = Colors.amberAccent;
    }
    if(widget.index==5){
      // strImg = "assets/images/Trucking.jpg";
      // strIcon = "assets/icons/07trucking.png";
      // clrBg = Colors.lime;
      strImg = "assets/images/Eurotunnel.jpg";
      strIcon = "assets/icons/04eurotunnel.png";
      clrBg = Colors.amberAccent;
    }
    if(widget.index==6){
      strImg = "assets/images/Tolls.jpg";
      strIcon = "assets/icons/06tolls.png";
      clrBg = Colors.tealAccent;
    }
    if(widget.index == 7){
      strImg = "assets/images/Bridge.jpg";
      strIcon = "assets/icons/05bridges.png";
      clrBg = Colors.deepPurple;
    }
    if(widget.index==8){
      strImg = "assets/images/Trucking.jpg";
      strIcon = "assets/icons/07trucking.png";
      clrBg = Colors.lime;
    }
    value1.imageAsset = strImg;
    value1.colorBg = clrBg;
    value1.icon = strIcon;
    listServiceModel.add(value1);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    String valueString = listServiceModel[0].colorBg.toString().split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Consumer<MyProvider>(
      builder: (context, provider, child){
        print("$TAG show provider services: ${provider.getIsShowServiceView}");
        print("$TAG orderDetail: ${widget.order_detail}");
        if(widget.order_detail != null){
          if(widget.order_detail.id_port_from == 12 && widget.order_detail.id_port_to == 13){
            selectedEuroRoute = euroTunnel_routes[0];
          }
          if(widget.order_detail.id_port_from == 13 && widget.order_detail.id_port_to == 12){
            selectedEuroRoute = euroTunnel_routes[1];
          }
          else{
            if(widget.order_detail.id_port_from == 20 || widget.order_detail.id_port_to == 14 ){
              selectedTunnel = tunnels[1];
              if(widget.order_detail.id_port_from == 20){
                selectedRoute = routes[0];
              }
              else{
                selectedRoute = routes[1];
              }
            if(widget.order_detail.id_port_from == 19 || widget.order_detail.id_port_to == 13){
              selectedTunnel = tunnels[0];
              if(widget.order_detail.id_port_from == 13){
                selectedRoute = routes[1];
              }
              else{
                selectedRoute = routes[0];
              }
            }
            }
          }
        }
        return Scaffold(
          backgroundColor: Color(value),
          body: Container(
            child: Stack(
              children: [
                if(getScreen.getOrientation()==Orientation.landscape)_buildTabletLayout(getScreen),
                if(getScreen.getOrientation()==Orientation.portrait)_buildPhoneLayout(getScreen),
                //title rotate
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: Container(
                        padding: EdgeInsets.only(top: 18.0),
                        width: getScreen.getOrientation()==Orientation.portrait? (getScreen.getWidth()/2)/4:(getScreen.getWidth()/2)/7,
                        height: (getScreen.getHeight()/2)/2,
                        color: Color(value).withOpacity(0.7),
                        child: Center(
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: new Text("Book Your Tickets", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)
                          ),
                        )
                    ),
                  ),
                ),
                _buildForm(provider, getScreen),
                //back home
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.only(top: 33.0, right: 10.0),
                    child: Container(
                      width: 120.0,
                      height: 40.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(color: Colors.white)),
                        color: getScreen.getOrientation()==Orientation.landscape ?  Colors.transparent:Colors.black.withOpacity(0.6),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          provider.setIsShowServiceView = false;
                        },
                        child: Text(
                          "Back Home",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if(isShowFormRegion)Container(
                  height: getScreen.getHeight(),
                  width: getScreen.getWidth(),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 300.0,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose Regison:"),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  hint: new Text("Select Region"),
                                  // value: selectedRegion,
                                  value: _region[0].label,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedRegion = newValue;
                                      _region[0].label;
                                    });
                                    // print(selectedRegion);
                                    print("$TAG select dropdown: ${_region[0].label}");
                                  },
                                  items: _region.map((Region map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.label,
                                      child: new Text(map.label,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0,),
                            Text("From:"),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  hint: new Text("Select Region"),
                                  // value: selectedRegion,
                                  value: _region[0].label,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedRegion = newValue;
                                      _region[0].label;
                                    });
                                    // print(selectedRegion);
                                    print("$TAG select dropdown: ${_region[0].label}");
                                  },
                                  items: _region.map((Region map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.label,
                                      child: new Text(map.label,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0,),
                            Text("To:"),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  hint: new Text("Select Region"),
                                  // value: selectedRegion,
                                  value: _region[0].label,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedRegion = newValue;
                                      _region[0].label;
                                    });
                                    // print(selectedRegion);
                                    print("$TAG select dropdown: ${_region[0].label}");
                                  },
                                  items: _region.map((Region map) {
                                    return new DropdownMenuItem<String>(
                                      value: map.label,
                                      child: new Text(map.label,
                                          style: new TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: (){
                                    if(isShowFormRegion){
                                      setState(() {
                                        isShowFormRegion = false;
                                      });
                                      return;
                                    }
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }//End Build

  Widget _buildTabletLayout(ScreenSize getScreen){
    return Container(
      height: getScreen.getHeight()/2,
      width: getScreen.getWidth(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset("${listServiceModel[0].imageAsset}", width: (getScreen.getWidth()/2), height: (getScreen.getHeight()/2)/2,
                fit: BoxFit.fitWidth,),
              Container(
                width: (getScreen.getWidth()/2),
                height: (getScreen.getHeight()/2)/2,
                child: Container(
                  padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
                  child: Image.asset("${listServiceModel[0].icon}",
                    fit: BoxFit.fitHeight,),
                )
              )
            ],
          ),
          Text("${listServiceModel[0].title}", style: MyStyle.titleServiceView),
          // if(widget.index==0||widget.index==2)Container(
          //   child: Container(
          //     width: 170.0,
          //     height: 30.0,
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(0.0),
          //           side: BorderSide(color: Colors.white)),
          //       color: Colors.transparent,
          //       textColor: Colors.white,
          //       padding: EdgeInsets.all(2.0),
          //       onPressed: () {
          //         print("$TAG Service locations ${listServiceModel[0].title}");
          //       },
          //       child: Text(
          //         "Service Location >",
          //         style: TextStyle(
          //           fontSize: 16.0,
          //           fontWeight: FontWeight.bold
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  Widget _buildPhoneLayout(ScreenSize getScreen){
    return Container(
      height: getScreen.getHeight()/2,
      width: getScreen.getWidth(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("${listServiceModel[0].imageAsset}", width: (getScreen.getWidth()), height: (getScreen.getHeight()/2)/2,
            fit: BoxFit.fitWidth,),
          Container(
              width: (getScreen.getWidth()),
              height: (getScreen.getHeight()/2)/5,
              child: Container(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: Image.asset("${listServiceModel[0].icon}",
                  fit: BoxFit.fitHeight,),
              )
          ),
          Text("${listServiceModel[0].title}", style: MyStyle.titleServiceViewPhone),
          SizedBox(height: 5.0,),
          // if(widget.index==0||widget.index==2)Container(
          //   child: Container(
          //     width: 170.0,
          //     height: 30.0,
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(0.0),
          //           side: BorderSide(color: Colors.white)),
          //       color: Colors.transparent,
          //       textColor: Colors.white,
          //       padding: EdgeInsets.all(2.0),
          //       onPressed: () {
          //         print("$TAG Service locations ${listServiceModel[0].title}");
          //       },
          //       child: Text(
          //         "Service Location >",
          //         style: TextStyle(
          //             fontSize: 16.0,
          //             fontWeight: FontWeight.bold
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildForm(MyProvider provider, ScreenSize getScreen){
    //Ferry
    if(widget.index==0){
      provider.setDashboardView = true;
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              if(widget.index==0||widget.index==2)Container(
                child: Container(
                  width: 170.0,
                  height: 30.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(2.0),
                    onPressed: () {
                      print("$TAG Service locations ${listServiceModel[0].title}");
                    },
                    child: Text(
                      "Service Location >",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              _buildRegions(getScreen),
              SizedBox(height: 40.0,),
              _buildFromToFerry(getScreen),
              SizedBox(height: 40.0,),
              _buildMakeBooking(getScreen),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      );
    }
    //Longbridge
    if(widget.index==1){
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.deepPurple,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                width: getScreen.getWidth(),
                color: Colors.transparent,
                child: Column(
                  children: [
                    //Form and To
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            longbridge_from_loading == true ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))
                              :Container(
                                width: getScreen.getWidth()/2.5,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(5),
                                    bottom: Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    hint: new Text("Select from"),
                                    isExpanded: true,
                                    value: selected_longbridge_from,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selected_longbridge_from = newValue;
                                        getLongBridgeTo(selected_longbridge_from.port_id);
                                      });
                                    },
                                    items: longbridge_fromList.map((from) {
                                      return DropdownMenuItem(
                                        value: from,
                                        child: new Text(from.name,
                                            style: new TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 25.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            longbridge_to_loading == true ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))
                              :Container(
                                width: getScreen.getWidth()/2.5,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(5),
                                    bottom: Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: new DropdownButton(
                                    hint: new Text("Select To"),
                                    isExpanded: true,
                                    value: selected_longbridge_to,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selected_longbridge_to = newValue;
                                      });
                                    },
                                    items: longbridge_toList.map((to) {
                                      return new DropdownMenuItem(
                                        value: to,
                                        child: new Text(to.name,
                                            style: new TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: 150,
                            child: Text(selected_longbridge_from == null ? 'Date of service' : 'Date of service ' + selected_longbridge_from.name, style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),),
                          ),
                          SizedBox(width: 5.0,),
                          new IconButton(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () async {
                              DateTime newDateTime = await showRoundedDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 1),
                              onTapDay: (DateTime dateTime, bool available) {
                                if (!available) {
                                  showDialog(
                                      context: context,
                                      builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                        CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                          Navigator.pop(context);
                                        },)
                                      ],));
                                }
                                return available;
                              },
                              borderRadius: 2,
                              );
                              if (newDateTime != null) {
                                setState(() {
                                  longbridge_date1 = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                                });
                              }
                          }),
                          Expanded(
                            child: Text(longbridge_date1, style: TextStyle(color: Colors.white, fontSize: 20)),
                          )
                        ]
                      )
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            width: 150,
                            child: Text(selected_longbridge_to == null ? 'Date of service' : 'Date of service ' + selected_longbridge_to.name, style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),),
                          ),
                          SizedBox(width: 5.0,),
                          new IconButton(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () async {
                              DateTime newDateTime = await showRoundedDatePicker(
                              context: context,
                              initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              lastDate: DateTime(DateTime.now().year + 1),
                              onTapDay: (DateTime dateTime, bool available) {
                                if (!available) {
                                  showDialog(
                                      context: context,
                                      builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                        CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                          Navigator.pop(context);
                                        },)
                                      ],));
                                }
                                return available;
                              },
                              borderRadius: 2,
                              );
                              if (newDateTime != null) {
                                setState(() {
                                  longbridge_date2 = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                                });
                              }
                          }),
                          Expanded(
                            child: Text(longbridge_date2, style: TextStyle(color: Colors.white, fontSize: 20)),
                          )
                        ]
                      )
                    ),
                    SizedBox(height: 10.0,),
                    //Regis vehicle
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vehicle Registration Number',
                                style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                child: TypeAheadFormField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: this._typeAheadController,
                                    decoration: InputDecoration(
                                      labelText: 'Registration Number',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    textCapitalization: TextCapitalization.characters,
                                    onChanged: (content){
                                      setState(() {
                                        selected_truck_num = content;
                                        veh_length_state = true;
                                        veh_type_state = true;
                                      });
                                    }
                                  ),          
                                  onSuggestionSelected: (suggestion) {
                                    this._typeAheadController.text = suggestion;
                                    selected_truck_num = suggestion;
                                    VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                                      setState(() {
                                        changeTruckState(json);
                                      });
                                    });
                                  }, 
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  suggestionsCallback: (pattern) {
                                    return getSuggestions(pattern);
                                  },
                                  transitionBuilder: (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a number';
                                    }
                                  },
                                  onSaved: (value) => this._selectedCity = value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    //Length and Type Vehicle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Length',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: getScreen.getWidth()/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                hint: Text('Vehicle Length'),
                                value: selectedVeh_length,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedVeh_length = newValue;
                                  });
                                },
                                items: vehicles_length.map((veh_length) {
                                  return DropdownMenuItem(
                                    child: new Text(veh_length),
                                    value: veh_length,
                                  );
                                }).toList(), 
                                
                              )
                            ),
                          ],
                        ),
                        SizedBox(width: 50.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: getScreen.getWidth()/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                hint: Text('Vehicle Type'),
                                value: selectedVeh_type,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedVeh_type = newValue;
                                  });
                                },
                                items: vehicles_type.map((type) {
                                  return DropdownMenuItem(
                                    child: new Text(type),
                                    value: type,
                                  );
                                }).toList(), 
                                
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    //Trailer vehicle
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trailer Registration Number',
                                style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                child: TypeAheadFormField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: this.trailerController,
                                    decoration: InputDecoration(
                                      labelText: 'Trailer Registration Number',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    textCapitalization: TextCapitalization.characters,
                                    onChanged: (content){
                                      setState(() {
                                        selected_trailer_num = content;
                                        trailer_veh_length_state = true;
                                        trailer_veh_type_state = true;
                                      });
                                    }
                                  ),          
                                  onSuggestionSelected: (suggestion) {
                                    this.trailerController.text = suggestion;
                                    selected_trailer_num = suggestion;
                                    VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                                      setState(() {
                                        changeTrailerState(json);
                                      });
                                    });
                                  }, 
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  suggestionsCallback: (pattern) {
                                    return getTrailerSuggestions(pattern);
                                  },
                                  transitionBuilder: (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a number';
                                    }
                                  },
                                  onSaved: (value) => this._selectedCity = value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    //Length and Type Vehicle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Length',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: getScreen.getWidth()/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                hint: Text('Trailer Vehicle Length'),
                                value: trailer_selectedVeh_length,
                                onChanged: (newValue) {
                                  setState(() {
                                    trailer_selectedVeh_length = newValue;
                                  });
                                },
                                items: vehicles_length.map((veh_length) {
                                  return DropdownMenuItem(
                                    child: new Text(veh_length),
                                    value: veh_length,
                                  );
                                }).toList(), 
                                
                              )
                            ),
                          ],
                        ),
                        SizedBox(width: 50.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type',
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: getScreen.getWidth()/2.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                hint: Text('Trailer Vehicle Type'),
                                value: trailer_selectedVeh_type,
                                // disabledHint: trailer_veh_type_state == false ? Text(trailer_selectedVeh_type) : null,
                                onChanged: (newValue) {
                                  setState(() {
                                    trailer_selectedVeh_type = newValue;
                                  });
                                },
                                items: vehicles_type.map((type) {
                                  return DropdownMenuItem(
                                    child: new Text(type),
                                    value: type,
                                  );
                                }).toList(), 
                                
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: offsetPopup(getScreen, widget.index),
                    ),
                    selected_longbridgeroute_list.length > 0 ? 
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                for(var route in selected_longbridgeroute_list)
                                  ListTile(
                                    title: Column(
                                      children: [
                                        Text(route.route_name, style: TextStyle(color: Colors.white, fontSize: 17)),
                                        Row(
                                          children: [
                                            Text(route.price, style: TextStyle(color: Colors.white, fontSize: 15)),
                                            SizedBox(width: 10,),
                                            Text(route.arrival, style: TextStyle(color: Colors.white, fontSize: 15)),
                                            SizedBox(width: 10,),
                                            Text(route.departure, style: TextStyle(color: Colors.white, fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selected_ferry_route_list.remove(route);
                                        });
                                      }),
                                  )
                              ],
                            )
                          ),
                        ),
                      ): Container(),
                    SizedBox(height: 10.0,),
                    //Desc
                    Container(
                      margin: EdgeInsets.only(top: 8.0, right: 10.0, bottom: 10.0, left: 10.0),
                      width: getScreen.getOrientation()==Orientation.portrait ? getScreen.getWidth() : getScreen.getWidth()-100.0,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: inputDesc,
                        maxLines: 5,
                        minLines: 3,
                        style: TextStyle(color: Colors.black, fontSize: 19.0),
                        decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white)),
                            hintText: 'type here',
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: 'Description ',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                            prefixIcon: const Icon(
                              Icons.notes_outlined,
                              color: Colors.white,
                            ),
                            prefixText: ' ',
                            suffixStyle: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    
                  ],
                )
              ),
              // _buildFromToFerry(getScreen),
              SizedBox(height: 20.0,),
              _buildMakeBooking(getScreen),
            ],
          ),
        ),
      );
    }
    //Train
    if(widget.index==2){
      provider.setDashboardView = true;
      return from_flag == false && vehicles_length_flag == false && vehicle_type_flag == false && vehicle_regnum_flag == false ? Container(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0, left: getScreen.getWidth() / 2),
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)),
        )
        : SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              if(widget.index==0||widget.index==2)Container(
                child: Container(
                  width: 170.0,
                  height: 30.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.transparent,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(2.0),
                    onPressed: () {
                      print("$TAG Service locations ${listServiceModel[0].title}");
                    },
                    child: Text(
                      "Service Location >",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 20.0,),
              // _buildRegions(getScreen),
              SizedBox(height: 40.0,),
              _buildFromTo(getScreen),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Date of Service', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 60.0,),
                    Text(service_date ,style: TextStyle(color: Colors.white, fontSize: 20)),
                    new IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () async {
                        DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year + 1),
                        onTapDay: (DateTime dateTime, bool available) {
                          if (!available) {
                            showDialog(
                                context: context,
                                builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                  CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                    Navigator.pop(context);
                                  },)
                                ],));
                          }
                          return available;
                        },
                        borderRadius: 2,
                        );
                        if (newDateTime != null) {
                          setState(() {
                            service_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          });
                        }
                    }),
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registration Number',style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 10.0,),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: this._typeAheadController,
                        decoration: InputDecoration(
                          labelText: 'Registration Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (content){
                          setState(() {
                            selected_truck_num = content;
                            veh_length_state = true;
                            veh_type_state = true;
                          });
                        }
                      ),          
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                        selected_truck_num = suggestion;
                        VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                          setState(() {
                            changeTruckState(json);
                          });
                        });
                      }, 
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return getSuggestions(pattern);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please select a number';
                        }
                      },
                      onSaved: (value) => this._selectedCity = value,
                    )
                  ]
                ),
              ),
              
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Length',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Length'),
                            value: selectedVeh_length,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_length = newValue;
                              });
                            },
                            items: vehicles_length.map((veh_length) {
                              return DropdownMenuItem(
                                child: new Text(veh_length),
                                value: veh_length,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                    SizedBox(width: 50.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Type'),
                            value: selectedVeh_type,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_type = newValue;
                              });
                            },
                            items: vehicles_type.map((type) {
                              return DropdownMenuItem(
                                child: new Text(type),
                                value: type,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                  ],
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Length', style:TextStyle(color: Colors.white, fontSize: 20)),
                    TextField(
                    // onFieldSubmitted: (value) => submitNumber(),
                      controller: euro_tunnel_meter,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Length',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: offsetPopup(getScreen, widget.index),
              ),
              
              SizedBox(height: selected_route_list.length > 0 ? 20.0 : 0,),
              selected_route_list.length > 0 ? 
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  height: 200,
                  color: Colors.black.withOpacity(0.8),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          for(var route in selected_route_list)
                            ListTile(
                              title: Column(
                                children:[
                                  Text(route.route_name, style: TextStyle(color: Colors.white)),
                                  Text(service_date + " " + route.departure + "-" + route.arrival + " " + route.price, style: TextStyle(color: Colors.white))
                                ]
                              ),
                              trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selected_route_list.remove(route);
                                          });
                                        }),
                            )
                        ],
                      )
                    ),
                  ),
                ): Container(),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('Comment', style: TextStyle(color: Colors.white, fontSize: 20)),
                    TextFormField(
                      controller: train_notes,
                      maxLines: 5,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Notes:',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 40.0,),
              _buildMakeBooking(getScreen),
            ],
          ),
        ),
      );
    }
    //Tunnel
    if(widget.index==3){
      provider.setDashboardView = true;
      return vehicles_length_flag == false && vehicle_type_flag == false && vehicle_regnum_flag == false && euro_type_flag == true ? Container(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0, left: getScreen.getWidth() / 2),
          child: CircularProgressIndicator(),
        )
        :SingleChildScrollView(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
          child: Container(
            color: Colors.red,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Select Tunnel', style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),),
                      SizedBox(width: 60.0,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          hint: Text('Please choose a tunnel'),
                          value: selectedTunnel,
                          onChanged: (newValue) {
                            
                            setState(() {
                              selectedTunnel = newValue;
                              if(selectedTunnel == "Mont Black Tunnel"){
                                tunnel_id = 1;
                              }
                              if(selectedTunnel == "Frezus Tunnel"){
                                tunnel_id = 2;
                              } 
                              changeVehicleClassType(tunnel_id);
                              changeVehicleEuroType(tunnel_id);
                            });
                          },
                          items: tunnels.map((tunnel) {
                            return DropdownMenuItem(
                              child: new Text(tunnel),
                              value: tunnel,
                            );
                          }).toList(), 
                          
                        )
                        
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Select Route', style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),),
                      SizedBox(width: 60.0,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          hint: Text('Please choose a route'),
                          value: selectedRoute,
                          onChanged: (newValue) {
                            setState(() {
                              selectedRoute = newValue;
                              if(selectedRoute == "IT-FR"){
                                id_direction_from = 2;
                                id_direction_to = 13;
                              }
                              else{
                                id_direction_from = 13;
                                id_direction_to = 2;
                              }
                            });
                          },
                          items: routes.map((route) {
                            return DropdownMenuItem(
                              child: new Text(route),
                              value: route,
                            );
                          }).toList(), 
                          
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Date of Crossing', style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),),
                      SizedBox(width: 60.0,),
                      Text(cross_date, style: TextStyle(color: Colors.white, fontSize: 24)),
                      new IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 1),
                          onTapDay: (DateTime dateTime, bool available) {
                            if (!available) {
                              showDialog(
                                  context: context,
                                  builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                    CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                      Navigator.pop(context);
                                    },)
                                  ],));
                            }
                            return available;
                          },
                          borderRadius: 2,
                          );
                          if (newDateTime != null) {
                            setState(() {
                              cross_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                            });
                          }
                      }),
                    ]
                  )
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Registration Number', style:TextStyle(color: Colors.white, fontSize: 20)),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                            labelText: 'Registration Number',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (content){
                            setState(() {
                              selected_truck_num = content;
                              veh_length_state = true;
                              veh_type_state = true;
                            });
                          }
                        ),          
                        onSuggestionSelected: (suggestion) {
                          this._typeAheadController.text = suggestion;
                          selected_truck_num = suggestion;
                          VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                            setState(() {
                              changeTruckState(json);
                            });
                          });
                        }, 
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return getSuggestions(pattern);
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select a number';
                          }
                        },
                        onSaved: (value) => this._selectedCity = value,
                      )
                    ]
                  ),
                ),
                
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Length',
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: getScreen.getWidth()/2.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              focusColor: Colors.white,
                              dropdownColor: Colors.white,
                              hint: Text('Vehicle Length'),
                              value: selectedVeh_length,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedVeh_length = newValue;
                                });
                              },
                              items: vehicles_length.map((veh_length) {
                                return DropdownMenuItem(
                                  child: new Text(veh_length),
                                  value: veh_length,
                                );
                              }).toList(), 
                              
                            )
                          ),
                        ],
                      ),
                      SizedBox(width: 50.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: getScreen.getWidth()/2.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              focusColor: Colors.white,
                              dropdownColor: Colors.white,
                              hint: Text('Vehicle Type'),
                              value: selectedVeh_type,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedVeh_type = newValue;
                                });
                              },
                              items: vehicles_type.map((type) {
                                return DropdownMenuItem(
                                  child: new Text(type),
                                  value: type,
                                );
                              }).toList(), 
                              
                            )
                          ),
                        ],
                      ),
                    ],
                  )
                ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vehicle Class Type', style: TextStyle(color: Colors.white, fontSize: 20)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          hint: Text('Vehicle Class Type'),
                          value: selectedVeh_class_type,
                          onChanged: (newValue) {
                            setState(() {
                              selectedVeh_class_type = newValue;
                            });
                          },
                          items: vehicles_class_type.map((class_type) {
                            return DropdownMenuItem(
                              child: Container(
                                child: new Text(class_type.vehicle_type_name),
                                width: getScreen.getWidth()-50,
                              ),
                              value: class_type,
                            );
                          }).toList(), 
                          
                        )
                      )
                    ]
                  ),
                ),
                if(selectedVeh_class_type != null && selectedVeh_class_type.vehicle_type_name == "Other")
                  SizedBox(width: 25.0,),
                if(selectedVeh_class_type != null && selectedVeh_class_type.vehicle_type_name == "Other")
                  Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                    width: getScreen.getWidth(),
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vehicle Class Other', style:TextStyle(color: Colors.white, fontSize: 20)),
                        TextField(
                        // onFieldSubmitted: (value) => submitNumber(),
                          controller: vehicle_class_other,
                          decoration: InputDecoration(
                            errorText: error,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Vehicle Class Other',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            )
                          ),
                        )
                      ]
                    )
                  ),

                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Euro Class Rating of the Vehicle', style: TextStyle(color: Colors.white, fontSize: 20)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          hint: Text('Euro Class Rating of the Vehicle'),
                          value: selectedEuro_veh_type,
                          onChanged: (newValue) {
                            setState(() {
                              selectedEuro_veh_type = newValue;
                            });
                          },
                          items: vehicles_euro_type.map((euro_type) {
                            return DropdownMenuItem(
                              child: Container(
                                child: new Text(euro_type.vehicle_euro_type_name),
                                width: getScreen.getWidth()-50,
                              ),
                              value: euro_type,
                            );
                          }).toList(), 
                          
                        )
                      )
                    ]
                  ),
                ),
                if(selectedEuro_veh_type != null && selectedEuro_veh_type.vehicle_euro_type_name == "Other")
                  SizedBox(width: 25.0,),
                if(selectedEuro_veh_type != null && selectedEuro_veh_type.vehicle_euro_type_name == "Other")
                  Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                    width: getScreen.getWidth(),
                    color: Colors.black.withOpacity(0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text('Vehicle Euro Class', style:TextStyle(color: Colors.white, fontSize: 20)),
                        TextField(
                        // onFieldSubmitted: (value) => submitNumber(),
                          controller: vehicle_euro_class,
                          decoration: InputDecoration(
                            errorText: error,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Vehicle Euro Class',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            )
                          ),
                        )
                      ]
                    )
                  ),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('Comment', style:TextStyle(color: Colors.white, fontSize: 20)),
                      TextFormField(
                      // onFieldSubmitted: (value) => submitNumber(),
                        controller: notes,
                        keyboardType: TextInputType.number,
                        maxLines: 5,
                        decoration: InputDecoration(
                          errorText: error,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Notes:',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          )
                        ),
                      )
                    ]
                  )
                ),
                SizedBox(height: 20.0,),
                _buildMakeBooking(getScreen),
              ],
            ),
          ),
        );
    }
    //Eurotunnel
    
    if(widget.index==4){
      provider.setDashboardView = true;
      return vehicles_length_flag == false && vehicle_type_flag && vehicle_regnum_flag ? Container(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0, left: getScreen.getWidth() / 2),
          child: CircularProgressIndicator(),
        ):
      SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.amberAccent,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getScreen.getOrientation()== Orientation.portrait?"Select a Route":'Select a Route', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 30.0,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: DropdownButton(
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        hint: Text('Please choose a route'),
                        value: selectedEuroRoute,
                        onChanged: (newValue) {
                          setState(() {
                            selectedEuroRoute = newValue;
                          });
                        },
                        items: euroTunnel_routes.map((route) {
                          return DropdownMenuItem(
                            child: Container(
                             child: new Text(route),
                            ),
                            value: route,
                          );
                        }).toList(), 
                        
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getScreen.getOrientation()== Orientation.portrait?"Date of Crossing":'Date of Crossing', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 60.0,),
                    Text(euro_cross_date, style: TextStyle(color: Colors.white, fontSize: 24)),
                    new IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () async {
                        DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year + 1),
                        onTapDay: (DateTime dateTime, bool available) {
                          if (!available) {
                            showDialog(
                                context: context,
                                builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                  CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                    Navigator.pop(context);
                                  },)
                                ],));
                          }
                          return available;
                        },
                        borderRadius: 2,
                        
                        );
                        if (newDateTime != null) {
                          setState(() {
                            euro_cross_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          });
                        }
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Registration Number', style:TextStyle(color: Colors.white, fontSize:20)),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: this._typeAheadController,
                        decoration: InputDecoration(
                          labelText: 'Registration Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (content){
                          setState(() {
                            selected_truck_num = content;
                            veh_length_state = true;
                            veh_type_state = true;
                          });
                        }
                      ),          
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                        selected_truck_num = suggestion;
                        VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                          setState(() {
                            changeTruckState(json);
                          });
                        });
                      }, 
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return getSuggestions(pattern);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please select a number';
                        }
                      },
                      onSaved: (value) => this._selectedCity = value,
                    )
                  ]
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Length',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Length'),
                            value: selectedVeh_length,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_length = newValue;
                              });
                            },
                            items: vehicles_length.map((veh_length) {
                              return DropdownMenuItem(
                                child: new Text(veh_length),
                                value: veh_length,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                    SizedBox(width: 50.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Type'),
                            value: selectedVeh_type,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_type = newValue;
                              });
                            },
                            items: vehicles_type.map((type) {
                              return DropdownMenuItem(
                                child: new Text(type),
                                value: type,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                  ],
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('Length (meters)', style: TextStyle(color: Colors.white, fontSize: 20)),
                    TextField(
                    // onFieldSubmitted: (value) => submitNumber(),
                      controller: euro_tunnel_meter,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Length (meters)',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('Comment', style:TextStyle(color: Colors.white, fontSize: 20)),
                    TextFormField(
                    // onFieldSubmitted: (value) => submitNumber(),
                      controller: euro_notes,
                      maxLines: 5,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Notes:',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: CheckboxListTile(
                    title: Text("Not Empty", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    value: empty_flag, 
                    onChanged: (value){
                      setState(() {
                        empty_flag = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    // contentPadding: EdgeInsets.all(0),
                  )
                ),
              ),
              empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    Text('MRN', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                      // onFieldSubmitted: (value) => submitNumber(),
                        controller: euro_mrn,
                        decoration: InputDecoration(
                          errorText: error,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'MRN',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          )
                        ),
                      )
                    )
                  ]
                )
              ) : Container(),
              empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                      onPressed: () {
                        getMRNFilesFromGallery();
                      },
                      child: Text(
                        "Attach File",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    mrn_files.length > 0 ? 
                    Container(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              for(var file in mrn_files)
                                Text(file.name, style:TextStyle(color: Colors.white, fontSize: 20.0)),
                            ],
                          )
                        ),
                      )
                    ): Container(child: Text('no file', style:TextStyle(color: Colors.white, fontSize: 20.0)))
                  ],
                ),
              ) : Container(),
              SizedBox(height: 20.0,),
              empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    Text('GRM', style:TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                      // onFieldSubmitted: (value) => submitNumber(),
                        controller: euro_grm,
                        decoration: InputDecoration(
                          errorText: error,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'GRM',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          )
                        ),
                      )
                    )
                  ]
                )
              ) : Container(),
              empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                      onPressed: () {
                        getGRMFilesFromGallery();
                      },
                      child: Text(
                        "Attach File",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    grm_files.length > 0 ? 
                    Container(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              for(var file in mrn_files)
                                Text(file.name, style:TextStyle(color: Colors.white, fontSize: 20.0)),
                            ],
                          )
                        ),
                      )
                    ): Container(child: Text('no file', style:TextStyle(color: Colors.white, fontSize: 20.0)))
                  ],
                ),
              ) : Container(),
              SizedBox(height: 20.0,),
              _buildMakeBooking(getScreen),
            ],
          ),
        ),
      );
    }
    if(widget.index == 5){            //English
      provider.setDashboardView = true;
      
      return vehicles_length_flag == false && vehicle_type_flag && vehicle_regnum_flag ? Container(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0, left: getScreen.getWidth() / 2),
          child: CircularProgressIndicator(),
        ):
      SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.amberAccent,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getScreen.getOrientation()== Orientation.portrait? "Select Location":'Select Location', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 30.0,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: DropdownButton(
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        hint: Text('First Selection'),
                        value: selected_english_messina,
                        onChanged: (newValue) {
                          setState(() {
                            selected_english_messina = newValue;
                            print("----english:${selected_english_messina}");
                            getSecondLocation(selected_english_messina);
                          });
                        },
                        items: english_messina.map((route) {
                          return DropdownMenuItem(
                            child: Container(
                             child: new Text(route),
                            ),
                            value: route,
                          );
                        }).toList(), 
                        
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getScreen.getOrientation()== Orientation.portrait? "Select Location":'Select Location', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 30.0,),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          hint: Text('Second Selection'),
                          value: selected_second_location,
                          onChanged: (newValue) {
                            setState(() {
                              selected_second_location = newValue;
                            });
                          },
                          items: second_location_list.map((route) {
                            return DropdownMenuItem(
                              child: Container(
                              child: new Text(route.route_name),
                              ),
                              value: route,
                            );
                          }).toList(), 
                          
                        )
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getScreen.getOrientation()== Orientation.portrait?"Select Date":'Select Date', style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 60.0,),
                    Text(enlgish_messina_date, style: TextStyle(color: Colors.white, fontSize: 24)),
                    new IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () async {
                        DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year + 1),
                        onTapDay: (DateTime dateTime, bool available) {
                          if (!available) {
                            showDialog(
                                context: context,
                                builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                  CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                    Navigator.pop(context);
                                  },)
                                ],));
                          }
                          return available;
                        },
                        borderRadius: 2,
                        
                        );
                        if (newDateTime != null) {
                          setState(() {
                            enlgish_messina_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          });
                        }
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children:[
                    Text('Registration Number', style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child:TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                            labelText: 'Registration Number',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (content){
                            setState(() {
                              selected_truck_num = content;
                              veh_length_state = true;
                              veh_type_state = true;
                            });
                          }
                        ),          
                        onSuggestionSelected: (suggestion) {
                          this._typeAheadController.text = suggestion;
                          selected_truck_num = suggestion;
                          VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                            setState(() {
                              changeTruckState(json);
                            });
                          });
                        }, 
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return getSuggestions(pattern);
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select a number';
                          }
                        },
                        onSaved: (value) => this._selectedCity = value,
                      )
                    )
                  ]
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text('Vehicle Length', style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),),
                        ),
                        SizedBox(width: 15.0,),
                        Expanded(
                          child: Text('Vehicle Type', style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              focusColor: Colors.white,
                              dropdownColor: Colors.white,
                              hint: Text('Vehicle Length'),
                              value: selectedVeh_length,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedVeh_length = newValue;
                                });
                              },
                              items: vehicles_length.map((veh_length) {
                                return DropdownMenuItem(
                                  child: new Text(veh_length),
                                  value: veh_length,
                                );
                              }).toList(), 
                              
                            )
                          ),
                        ),
                        SizedBox(width: 15.0,),
                        Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Type'),
                            value: selectedVeh_type,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_type = newValue;
                              });
                            },
                            items: vehicles_type.map((type) {
                              return DropdownMenuItem(
                                child: new Text(type),
                                value: type,
                              );
                            }).toList(), 
                            
                          )
                        ),
                        )
                      ]
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Length', style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),),
                    SizedBox(height: 15.0,),
                    TextField(
                    // onFieldSubmitted: (value) => submitNumber(),
                      controller: euro_tunnel_meter,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Length (meters)',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: offsetPopup(getScreen, widget.index),
              ),
              selected_messina_route_list.length > 0 ? 
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  height: 200,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          for(var route in selected_messina_route_list)
                            ListTile(
                              title: Column(
                                children: [
                                  Text(route.route_name, style: TextStyle(color: Colors.white, fontSize: 17)),
                                  Row(
                                    children: [
                                      Text(route.price, style: TextStyle(color: Colors.white, fontSize: 15)),
                                      SizedBox(width: 10,),
                                      Text(route.arrival, style: TextStyle(color: Colors.white, fontSize: 15)),
                                      SizedBox(width: 10,),
                                      Text(route.departure, style: TextStyle(color: Colors.white, fontSize: 15)),
                                    ],
                                  )
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selected_ferry_route_list.remove(route);
                                  });
                                }),
                            )
                        ],
                      )
                    ),
                  ),
                ): Container(),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: TextFormField(
                // onFieldSubmitted: (value) => submitNumber(),
                  controller: euro_notes,
                  maxLines: 5,
                  decoration: InputDecoration(
                    errorText: error,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Notes:',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.white)
                    )
                  ),
                )
              ),
              SizedBox(height: 20.0,),
              selected_english_messina == "English-channel" ? 
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: CheckboxListTile(
                    title: Text("Not Empty", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    value: empty_flag, 
                    onChanged: (value){
                      setState(() {
                        empty_flag = value;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    // contentPadding: EdgeInsets.all(0),
                  )
                ),
              ) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    Text('MRN', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                      // onFieldSubmitted: (value) => submitNumber(),
                        controller: euro_mrn,
                        decoration: InputDecoration(
                          errorText: error,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'MRN',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          )
                        ),
                      )
                    )
                  ]
                )
              ) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                      onPressed: () {
                        getMRNFilesFromGallery();
                      },
                      child: Text(
                        "Attach File",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    mrn_files.length > 0 ? 
                    Container(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              for(var file in mrn_files)
                                Text(file.name, style:TextStyle(color: Colors.white, fontSize: 20.0)),
                            ],
                          )
                        ),
                      )
                    ): Container(child: Text('no file', style:TextStyle(color: Colors.white, fontSize: 20.0)))
                  ],
                ),
              ) : Container(),
              SizedBox(height: 20.0,),
              selected_english_messina == "English-channel" && empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    Text('GRM', style:TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                      // onFieldSubmitted: (value) => submitNumber(),
                        controller: euro_grm,
                        decoration: InputDecoration(
                          errorText: error,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'GRM',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                          )
                        ),
                      )
                    )
                  ]
                )
              ) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? SizedBox(height: 20.0,) : Container(),
              selected_english_messina == "English-channel" && empty_flag == true ? Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                      onPressed: () {
                        getGRMFilesFromGallery();
                      },
                      child: Text(
                        "Attach File",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    grm_files.length > 0 ? 
                    Container(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              for(var file in mrn_files)
                                Text(file.name, style:TextStyle(color: Colors.white, fontSize: 20.0)),
                            ],
                          )
                        ),
                      )
                    ): Container(child: Text('no file', style:TextStyle(color: Colors.white, fontSize: 20.0)))
                  ],
                ),
              ) : Container(),
              SizedBox(height: 20.0,),
              _buildMakeBooking(getScreen),
            ],
          ),
        ),
      );
    }
    //Trucking
    if(widget.index==8){
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
          color: Colors.lime,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0,),
              trucking_loading == true ? CircularProgressIndicator() : 
                Container(
                  color: Colors.black.withOpacity(0.8),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: Text('Service Type', style:TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text(''),
                            value: selectedTruckingService,
                            onChanged: (newValue) {
                              setState(() {
                                selectedTruckingService = newValue;
                              });
                            },
                            items: trucking_list.map((trucking) {
                              return DropdownMenuItem(
                                child: new Text(trucking.name),
                                value: trucking,
                              );
                            }).toList(), 
                              
                          )
                        )
                      )
                    ],
                  )
                  
                ),
              SizedBox(height: 20.0,),
              selectedTruckingService != null && selectedTruckingService.trucking_type_id == -1 ?
                Container(
                  color: Colors.black.withOpacity(0.8),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        child: Text('Other', style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),),
                      ),
                      SizedBox(width: 5.0,),
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: other_trucking,
                            decoration: InputDecoration(
                              errorText: error,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.white)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.white)
                              )
                            ),
                          )
                        )
                      ),
                    ],
                  ),
                ) : Container(),
              SizedBox(height: 20.0,),
              Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text('Date of Service', style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    ),
                    SizedBox(width: 5.0,),
                    new IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () async {
                        DateTime newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year + 1),
                        onTapDay: (DateTime dateTime, bool available) {
                          if (!available) {
                            showDialog(
                                context: context,
                                builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                  CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                    Navigator.pop(context);
                                  },)
                                ],));
                          }
                          return available;
                        },
                        borderRadius: 2,
                        );
                        if (newDateTime != null) {
                          setState(() {
                            trucking_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                          });
                        }
                    }),
                    Expanded(
                      child: Text(trucking_date, style: TextStyle(color: Colors.white, fontSize: 20)),
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text('From location', style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: from_trucking,
                          decoration: InputDecoration(
                            errorText: error,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            )
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      child: Text('To location', style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),),
                    ),
                    SizedBox(width: 5.0,),
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: to_trucking,
                          decoration: InputDecoration(
                            errorText: error,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.white)
                            )
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.all(10),
                child: Text('Comment', style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),),
              ),
              SizedBox(height: 10.0,),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: comment_trucking,
                  decoration: InputDecoration(
                    errorText: error,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.white)
                    )
                  ),
                  maxLines: 5,
                )
              ),
              SizedBox(height: 20.0,),
              _buildMakeBooking(getScreen),
            ],
          ),
        ),
      );
    }
    //Tolls
    if(widget.index==6){
      provider.setDashboardView = true;
      return Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-70),
          child: Container(
            color: Colors.tealAccent,
            child: Column(
              children: [
                //Text("TELEPASS", style: TextStyle(color: Colors.white, fontSize: 30.0,),),
                //SizedBox(height: 10.0,),
                toll_flag == true ? CircularProgressIndicator() :
                  toll_list.length > 0 ?
                    Container(
                      width: double.infinity,
                      height: 320,
                      child: RawScrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        thumbColor: Colors.blue,
                        thickness: 2,
                        child:ListView.builder(
                          controller: _scrollController,
                          itemCount: toll_list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new CheckboxListTile(
                              title: new Text(toll_list[index].name, style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),),
                              value: toll_list[index].status,
                              onChanged: (bool value) {
                                setState(() {
                                  toll_list[index].status = value;
                                });
                              },
                            );
                          }
                        )
                      ),
                    ):
                    Container(
                      child: Text('No country'),
                    ),
                SizedBox(height: 20.0,),
                _buildMakeBooking(getScreen),
              ],
            ),
          ),
        )
      );
    }
    //Bridge Pass
    if(widget.index == 7){
      provider.setDashboardView = true;
      return bridge_flag == false && vehicles_length_flag == false && vehicle_type_flag == false && manufacturer_flag == true && country_flag == true ? Container(
          padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0, left: getScreen.getWidth() / 2),
          child: CircularProgressIndicator(),
        )
      :SingleChildScrollView(
        padding: EdgeInsets.only(top: (getScreen.getHeight()/2)-30.0),
        child: Container(
            color: Colors.deepPurple,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('Bridge', style: TextStyle(color: Colors.white, fontSize: 20)),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              focusColor: Colors.white,
                              dropdownColor: Colors.white,
                              hint: Text('Please choose a Bridge'),
                              value: selectedBridge,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedBridge = newValue;
                                });
                              },
                              items: bridge_routes.map((bridge) {
                                return DropdownMenuItem(
                                  child: Container(
                                  child: new Text(bridge.bridge_name),
                                  ),
                                  value: bridge,
                                );
                              }).toList(), 
                              
                            )
                          )
                        ]
                      )
                    ),
                    if(selectedBridge != null && selectedBridge.bridge_name == "Other")
                      SizedBox(width: 15.0,),
                    if(selectedBridge != null && selectedBridge.bridge_name == "Other")
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text('Bridge Other', style: TextStyle(color: Colors.white, fontSize: 20)),
                            Container(
                              height: 50,
                              child: TextField(
                              // onFieldSubmitted: (value) => submitNumber(),
                                controller: bridge_other,
                                decoration: InputDecoration(
                                  errorText: error,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Bridge Other',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.white)
                                  )
                                ),
                              )
                            )
                          ]
                        )
                      )
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                  width: getScreen.getWidth(),
                  color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Date of Crossing', style: TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),),
                      SizedBox(width: 60.0,),
                      Text(bridge_date, style: TextStyle(color: Colors.white, fontSize: 24)),
                      new IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 1),
                          onTapDay: (DateTime dateTime, bool available) {
                            if (!available) {
                              showDialog(
                                  context: context,
                                  builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                                    CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                      Navigator.pop(context);
                                    },)
                                  ],));
                            }
                            return available;
                          },
                          borderRadius: 2,
                          );
                          if (newDateTime != null) {
                            setState(() {
                              bridge_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                            });
                          }
                      }),
                    ]
                  )
                ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Text('Registration Number', style: TextStyle(color: Colors.white, fontSize:20)),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: this._typeAheadController,
                        decoration: InputDecoration(
                          labelText: 'Registration Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (content){
                          setState(() {
                            selected_truck_num = content;
                            veh_length_state = true;
                            veh_type_state = true;
                          });
                        }
                      ),          
                      onSuggestionSelected: (suggestion) {
                        this._typeAheadController.text = suggestion;
                        selected_truck_num = suggestion;
                        VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                          setState(() {
                            changeTruckState(json);
                          });
                        });
                      }, 
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return getSuggestions(pattern);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please select a number';
                        }
                      },
                      onSaved: (value) => this._selectedCity = value,
                    )
                  ]
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Length',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Length'),
                            value: selectedVeh_length,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_length = newValue;
                              });
                            },
                            items: vehicles_length.map((veh_length) {
                              return DropdownMenuItem(
                                child: new Text(veh_length),
                                value: veh_length,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                    SizedBox(width: 50.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: getScreen.getWidth()/2.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            hint: Text('Vehicle Type'),
                            value: selectedVeh_type,
                            onChanged: (newValue) {
                              setState(() {
                                selectedVeh_type = newValue;
                              });
                            },
                            items: vehicles_type.map((type) {
                              return DropdownMenuItem(
                                child: new Text(type),
                                value: type,
                              );
                            }).toList(), 
                            
                          )
                        ),
                      ],
                    ),
                  ],
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vehicle's Manufacturer", style: TextStyle(color: Colors.white, fontSize: 20)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: DropdownButton(
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        hint: Text("Vehicle's Manufacturer"),
                        value: selected_manufacturer,
                        onChanged: (newValue) {
                          setState(() {
                            selected_manufacturer = newValue;
                          });
                        },
                        items: manufacturer_list.map((manufacturer) {
                          return DropdownMenuItem(
                            child: Container(
                              child: new Text(manufacturer.vehicle_manufacturer_name),
                            ),
                            value: manufacturer,
                          );
                        }).toList(), 
                        
                      )
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle Model', style: TextStyle(color: Colors.white, fontSize:20)),
                            TextField(
                              controller: vehicle_model,
                              decoration: InputDecoration(
                                errorText: error,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Vehicle Model',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.white)
                                )
                              ),
                            )
                          ]
                        )
                      )
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Text('Vehicle Color', style:TextStyle(color: Colors.white, fontSize:20)),
                          TextField(
                            controller: vehicle_color,
                              decoration: InputDecoration(
                                errorText: error,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Vehicle Color',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(color: Colors.white)
                                )
                              ),
                          )
                        ]
                      )
                    )
                  ],
                )
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vehicle's Registration Country", style:TextStyle(color: Colors.white, fontSize:20)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        hint: Text("Vehicle's Registration Country"),
                        value: selected_country,
                        onChanged: (newValue) {
                          setState(() {
                            selected_country = newValue;
                          });
                        },
                        items: country_list.map((country) {
                          return DropdownMenuItem(
                            child: Container(
                              child: new Text(country.country_name),
                            ),
                            value: country,
                          );
                        }).toList(), 
                        
                      )
                    )
                  ]
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vehicle Euro Class Rating', style:TextStyle(color: Colors.white, fontSize:20)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: DropdownButton(
                        isExpanded: true,
                        focusColor: Colors.white,
                        dropdownColor: Colors.white,
                        hint: Text('Vehicle Euro Class Rating'),
                        value: selectedEuroClass,
                        onChanged: (newValue) {
                          setState(() {
                            selectedEuroClass = newValue;
                          });
                        },
                        items: euroclass_routes.map((euro) {
                          return DropdownMenuItem(
                            child: Container(
                              child: new Text(euro),
                            ),
                            value: euro,
                          );
                        }).toList(), 
                        
                      )
                    )
                  ]
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,right:getScreen.getOrientation()== Orientation.portrait?10.0:0.0,),
                width: getScreen.getWidth(),
                color: Colors.black.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Comment', style: TextStyle(color: Colors.white, fontSize:20)),
                    TextFormField(
                    // onFieldSubmitted: (value) => submitNumber(),
                      controller: euro_notes,
                      maxLines: 5,
                      decoration: InputDecoration(
                        errorText: error,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Notes:',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.white)
                        )
                      ),
                    )
                  ]
                )
              ),
              SizedBox(height: 20.0,),
              _buildMakeBooking(getScreen),
            ]
          )
        )
      );
    }
  }

  Widget _buildRegions(ScreenSize getScreen){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: getScreen.getWidth(),
      color: Colors.black.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Regions", style: TextStyle(color: Colors.white, fontSize: 20.0),),
          SizedBox(width: 20.0,),
          Container(
            // width: 170.0,
            // padding: EdgeInsets.all(10.0),
            child: ferry_region_loading == true ? CircularProgressIndicator()
              : ferry_region_list.length > 0 ? 
                Container(
                  width: getScreen.getWidth()/2.5,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                      bottom: Radius.circular(5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: new Text("Select Region"),
                      isExpanded: true,
                      value: selected_ferry_region,
                      isDense: true,
                      onChanged: (newValue) {
                        setState(() {
                          selected_ferry_region = newValue;
                          getFerryFrom(selected_ferry_region);
                        });
                      },
                      items: ferry_region_list.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: new Text(region.name,
                              style: new TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                ) : Container(child: Text('no region'))           
            ),
            
          ],
      ),
    );
  }
  void getFerryFrom(FerryRegion region){
    ferry_from_loading = true;
    ferry_from_list = [];
    FerryModule.getFerryFrom(region.region_id).then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          ferry_from_list.add(value[i]);
        }
        selected_ferry_from = null;
      }
      setState(() {
        ferry_from_loading = false;
      });
    });
  }
  Future<void> getFerryTo(FerryRegion region, FerryFrom ferryFrom) async {
    ferry_to_loading = true;
    ferry_to_list = [];
    await FerryModule.getFerryTo(region.region_id, ferryFrom.port_id).then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          ferry_to_list.add(value[i]);
        }
        selected_ferry_to = null;
      }
      setState(() {
        ferry_to_loading = false;
      });
    });
  }

  Widget _buildFromToFerry(ScreenSize getScreen){
    return Container(
      padding: EdgeInsets.all(10.0),
      width: getScreen.getWidth(),
      color: Colors.transparent,
      child: Column(
        children: [
          //Form and To
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  ferry_from_loading == true ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))
                    :Container(
                      width: getScreen.getWidth()/2.5,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5),
                          bottom: Radius.circular(5),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: new Text("Select from"),
                          isExpanded: true,
                          value: selected_ferry_from,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selected_ferry_from = newValue;
                              getFerryTo(selected_ferry_region, selected_ferry_from);
                            });
                          },
                          items: ferry_from_list.map((from) {
                            return DropdownMenuItem(
                              value: from,
                              child: new Text(from.name,
                                  style: new TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  ferry_to_loading == true ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))
                    :Container(
                      width: getScreen.getWidth()/2.5,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(5),
                          bottom: Radius.circular(5),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          hint: new Text("Select Region"),
                          isExpanded: true,
                          value: selected_ferry_to,
                          isDense: true,
                          onChanged: (newValue) {
                            setState(() {
                              selected_ferry_to = newValue;
                              
                            });
                          },
                          items: ferry_to_list.map((ferry_to) {
                            return new DropdownMenuItem(
                              value: ferry_to,
                              child: new Text(ferry_to.name,
                                  style: new TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text('Date of Service', style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),),
                ),
                SizedBox(width: 5.0,),
                new IconButton(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                    DateTime newDateTime = await showRoundedDatePicker(
                    context: context,
                    initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    lastDate: DateTime(DateTime.now().year + 1),
                    onTapDay: (DateTime dateTime, bool available) {
                      if (!available) {
                        showDialog(
                            context: context,
                            builder: (c) => CupertinoAlertDialog(title: Text("This date cannot be selected."),actions: <Widget>[
                              CupertinoDialogAction(child: Text("OK"),onPressed: (){
                                Navigator.pop(context);
                              },)
                            ],));
                      }
                      return available;
                    },
                    borderRadius: 2,
                    );
                    if (newDateTime != null) {
                      setState(() {
                        ferry_date = newDateTime.year.toString() + "-" + newDateTime.month.toString() + "-" + newDateTime.day.toString();
                      });
                    }
                }),
                Expanded(
                  child: Text(ferry_date, style: TextStyle(color: Colors.white, fontSize: 20)),
                )
              ]
            )
          ),
          SizedBox(height: 10.0,),
          //Regis vehicle
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Registration Number',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this._typeAheadController,
                          decoration: InputDecoration(
                            labelText: 'Registration Number',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (content){
                            setState(() {
                              selected_truck_num = content;
                              veh_length_state = true;
                              veh_type_state = true;
                            });
                          }
                        ),          
                        onSuggestionSelected: (suggestion) {
                          this._typeAheadController.text = suggestion;
                          selected_truck_num = suggestion;
                          VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                            setState(() {
                              changeTruckState(json);
                            });
                          });
                        }, 
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return getSuggestions(pattern);
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select a number';
                          }
                        },
                        onSaved: (value) => this._selectedCity = value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          //Length and Type Vehicle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Length',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: getScreen.getWidth()/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      hint: Text('Vehicle Length'),
                      value: selectedVeh_length,
                      // disabledHint: veh_length_state == false ? Text(selectedVeh_length) : null,
                      onChanged: (newValue) {
                        setState(() {
                          selectedVeh_length = newValue;
                        });
                      },
                      items: vehicles_length.map((veh_length) {
                        return DropdownMenuItem(
                          child: new Text(veh_length),
                          value: veh_length,
                        );
                      }).toList(), 
                      
                    )
                  ),
                ],
              ),
              SizedBox(width: 50.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: getScreen.getWidth()/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      hint: Text('Vehicle Type'),
                      value: selectedVeh_type,
                      // disabledHint: veh_type_state == false ? Text(selectedVeh_type) : null,
                      onChanged: (newValue) {
                        setState(() {
                          selectedVeh_type = newValue;
                        });
                      },
                      items: vehicles_type.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type),
                          value: type,
                        );
                      }).toList(), 
                      
                    )
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          //Trailer vehicle
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trailer Registration Number',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: this.trailerController,
                          decoration: InputDecoration(
                            labelText: 'Trailer Registration Number',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (content){
                            setState(() {
                              selected_trailer_num = content;
                              trailer_veh_length_state = true;
                              trailer_veh_type_state = true;
                            });
                          }
                        ),          
                        onSuggestionSelected: (suggestion) {
                          this.trailerController.text = suggestion;
                          selected_trailer_num = suggestion;
                          VehicleModule.changeTruckInfo(UserModule.user.sessId, suggestion).then((json){
                            setState(() {
                              changeTrailerState(json);
                            });
                          });
                        }, 
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          return getTrailerSuggestions(pattern);
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please select a number';
                          }
                        },
                        onSaved: (value) => this._selectedCity = value,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          //Length and Type Vehicle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Length',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: getScreen.getWidth()/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      hint: Text('Trailer Vehicle Length'),
                      value: trailer_selectedVeh_length,
                      // disabledHint: trailer_veh_length_state == false ? Text(trailer_selectedVeh_length) : null,
                      onChanged: (newValue) {
                        setState(() {
                          trailer_selectedVeh_length = newValue;
                        });
                      },
                      items: vehicles_length.map((veh_length) {
                        return DropdownMenuItem(
                          child: new Text(veh_length),
                          value: veh_length,
                        );
                      }).toList(), 
                      
                    )
                  ),
                ],
              ),
              SizedBox(width: 50.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type',
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: getScreen.getWidth()/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      hint: Text('Trailer Vehicle Type'),
                      value: trailer_selectedVeh_type,
                      // disabledHint: trailer_veh_type_state == false ? Text(trailer_selectedVeh_type) : null,
                      onChanged: (newValue) {
                        setState(() {
                          trailer_selectedVeh_type = newValue;
                        });
                      },
                      items: vehicles_type.map((type) {
                        return DropdownMenuItem(
                          child: new Text(type),
                          value: type,
                        );
                      }).toList(), 
                      
                    )
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: offsetPopup(getScreen, widget.index),
          ),
          selected_ferry_route_list.length > 0 ? 
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      for(var route in selected_ferry_route_list)
                        ListTile(
                          title: Column(
                            children: [
                              Text(route.route_name, style: TextStyle(color: Colors.white, fontSize: 17)),
                              Row(
                                children: [
                                  Text(route.price, style: TextStyle(color: Colors.white, fontSize: 15)),
                                  SizedBox(width: 10,),
                                  Text(route.arrival, style: TextStyle(color: Colors.white, fontSize: 15)),
                                  SizedBox(width: 10,),
                                  Text(route.departure, style: TextStyle(color: Colors.white, fontSize: 15)),
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                selected_ferry_route_list.remove(route);
                              });
                            }),
                        )
                    ],
                  )
                ),
              ),
            ): Container(),
          SizedBox(height: 10.0,),
          //Desc
          Container(
            margin: EdgeInsets.only(top: 8.0, right: 10.0, bottom: 10.0, left: 10.0),
            width: getScreen.getOrientation()==Orientation.portrait ? getScreen.getWidth() : getScreen.getWidth()-100.0,
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              controller: inputDesc,
              maxLines: 5,
              minLines: 3,
              style: TextStyle(color: Colors.black, fontSize: 19.0),
              decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white)),
                  hintText: 'type here',
                  hintStyle: TextStyle(color: Colors.white),
                  labelText: 'Description ',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                  prefixIcon: const Icon(
                    Icons.notes_outlined,
                    color: Colors.white,
                  ),
                  prefixText: ' ',
                  suffixStyle: const TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 10.0,),
          //View routes
          // Container(
          //   width: (getScreen.getWidth())-80,
          //   height: 40.0,
          //   child: FlatButton(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(0.0),
          //         side: BorderSide(color: Colors.white)),
          //     textColor: Colors.white,
          //     color: Colors.teal,
          //     padding: EdgeInsets.all(8.0),
          //     onPressed: () {},
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.not_listed_location_sharp),
          //         SizedBox(width: 8.0,),
          //         Text(
          //           "View Available Routes",
          //           style: TextStyle(
          //             fontSize: 18.0,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      )
    );
  }

  Widget _buildFromTo(ScreenSize getScreen){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: getScreen.getWidth(),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: TextStyle(
                  // decoration: TextDecoration.underline,
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
              Container(
                width: getScreen.getWidth()/2.1,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                    bottom: Radius.circular(5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    hint: new Text("Select Region"),
                    value: selected_from,
                    //value: from_region[0],
                    isDense: true,
                    onChanged: (String newValue) {
                      
                      selected_from = newValue;
                      selected_to = null;
                      setState(() {
                        to_flag = true;
                        to_region.clear();
                        for(int i = 0; i < from_region.length; i++){
                          if(newValue == from_region[i]){
                            TrainModule.getTo(TrainModule.froms[i].port_id).then((value){
                              setState(() {
                              if(TrainModule.tos.length > 0){
                                for(int i = 0; i < TrainModule.tos.length; i++){
                                  to_region.add(TrainModule.tos[i].port_name + ", " + TrainModule.tos[i].country_name);
                                }
                              }
                              to_flag = false;
                              });
                              
                            });
                            break;
                          }
                        }
                      });
                      
                    },
                    items: from_region.map((type) {
                      return new DropdownMenuItem<String>(
                        value: type,
                        child: new Text(type,
                            style: new TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: TextStyle(
                  // decoration: TextDecoration.underline,
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
              to_flag == true ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red))
              : Container(
                width: getScreen.getWidth()/2.1,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                    bottom: Radius.circular(5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: new DropdownButton(
                    hint: new Text("Select Region"),
                    value: selected_to,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        selected_to = newValue;
                      });
                    },
                    items: to_region.map((type) {
                      return new DropdownMenuItem(
                        value: type,
                        child: new Text(type,
                            style: new TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMakeBooking(ScreenSize getScreen){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      width: getScreen.getWidth(),
      color: Colors.black.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Container(
              width: 200.0,
              height: 30.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.white)),
                color: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                onPressed: () {
                  onMakeBooking();
                  print("$TAG Make booking: ${listServiceModel[0].title}");
                },
                child: Text(
                  "Make Booking",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  void getSecondLocation(String first_location) {
    second_location_list = [];
    if(first_location == "English-channel"){
      EnglishMessina eng_messina = EnglishMessina(
        route_name: "Calais, France – Dover, United Kingdom",
        fromId: 1000007,
        toId: 1000011
      );
      second_location_list.add(eng_messina);
      eng_messina = EnglishMessina(
        route_name: "Dover, United Kingdom - Calais, France",
        fromId: 1000011,
        toId: 1000007
      );
      second_location_list.add(eng_messina);
      eng_messina = EnglishMessina(
        route_name: "Dover, United Kingdom – Dunkerque, France",
        fromId: 1000011,
        toId: 1000012
      );
      second_location_list.add(eng_messina);
      eng_messina = EnglishMessina(
        route_name: "Dunkerque, France - Dover, United Kingdom",
        fromId: 1000012,
        toId: 1000011
      );
      second_location_list.add(eng_messina);
      selected_second_location = null;
    }
    else{
      EnglishMessina eng_messina = EnglishMessina(
        route_name: "Messina – Villa Saint Giovanni",
        fromId: 1170,
        toId: 1198
      );
      second_location_list.add(eng_messina);
      eng_messina = EnglishMessina(
        route_name: "Villa Saint Giovanni - Messina",
        fromId: 1198,
        toId: 1170
      );
      second_location_list.add(eng_messina);
      selected_second_location = null;
    }
    setState(() {
      
    });
  }
  Future<void> getMRNFilesFromGallery() async {
    await FilePicker.platform.pickFiles(allowMultiple: true, allowedExtensions: ['jpg', 'pdf', 'png'], type: FileType.custom).then((value){
      if(value != null){
        mrn_files = value.files;
        // file_name = file.name; //attach_file.substring(attach_file.lastIndexOf('/') + 1, attach_file.lastIndexOf('.') - 1);
        // file_extension = file.extension; //attach_file.substring(attach_file.lastIndexOf('.') + 1, attach_file.length);
        // print("------path:${file_extension}");
        setState(() {
        });
      }
    });
  }
  Future<void> getGRMFilesFromGallery() async {
    await FilePicker.platform.pickFiles(allowMultiple: true, allowedExtensions: ['jpg', 'pdf', 'png'], type: FileType.custom).then((value){
      if(value != null){
        grm_files = value.files;
        // file_name = file.name; //attach_file.substring(attach_file.lastIndexOf('/') + 1, attach_file.lastIndexOf('.') - 1);
        // file_extension = file.extension; //attach_file.substring(attach_file.lastIndexOf('.') + 1, attach_file.length);
        // print("------path:${file_extension}");
        setState(() {
        });
      }
    });
  }
  void changeVehicleClassType(int id){
    
    if(id == 1){
      vehicles_class_type.clear();
      if(VehicleModule.class_list.length > 0){
        for(int i = 0; i < VehicleModule.class_list.length; i++){
          vehicles_class_type.add(VehicleModule.class_list[i]);
        }
        vehicles_class_type.removeAt(2);
        vehicles_class_type.removeAt(2);
        vehicles_class_type.removeAt(4);
        selectedVeh_class_type = null;
      }
      
    }
    if(id == 2){
      vehicles_class_type.clear();
      if(VehicleModule.class_list.length > 0){
        for(int i = 0; i < VehicleModule.class_list.length; i++){
          vehicles_class_type.add(VehicleModule.class_list[i]);
        }
        vehicles_class_type.removeAt(4);
        vehicles_class_type.removeAt(4);
        selectedVeh_class_type = null;
      }
    }
  }
  void changeVehicleEuroType(int id){
    if(id == 1){
      vehicles_euro_type.clear();
      if(VehicleModule.eurotype_list.length > 0){
        for(int i = 0; i < VehicleModule.eurotype_list.length; i++){
          vehicles_euro_type.add(VehicleModule.eurotype_list[i]);
        }
        vehicles_euro_type.removeAt(0);
        vehicles_euro_type.removeAt(0);
        vehicles_euro_type.removeAt(0);
        vehicles_euro_type.removeAt(0);
        selectedEuro_veh_type = null;
      }
    }
    if(id == 2){
      vehicles_euro_type.clear();
      if(VehicleModule.eurotype_list.length > 0){
        for(int i = 0; i < VehicleModule.eurotype_list.length; i++){
          vehicles_euro_type.add(VehicleModule.eurotype_list[i]);
        }
        vehicles_euro_type.removeAt(0);
        vehicles_euro_type.removeAt(0);
        vehicles_euro_type.removeAt(0);
        selectedEuro_veh_type = null;
      }
    }
  }
  onMakeBooking() async {
    if(widget.index == 3){    //tunnel
      String json_data = jsonEncode({
        "PHPSESSID" : UserModule.user.sessId,
        "tunnel" : selectedTunnel,
        "id_tunnel": tunnel_id,
        "route" : selectedRoute,
        "id_direction_from": id_direction_from,
        "id_direction_to": id_direction_to,
        "date" : cross_date,
        "truck_num" : selected_truck_num,
        "truck_feature_category" : selectedVeh_length,
        "truck_type_name" : selectedVeh_type,
        "vehicle_type_id": selectedVeh_class_type.vehicle_type_id,
        "vehicle_type_name" : selectedVeh_class_type.vehicle_type_name,
        "vehicle_type_other": vehicle_class_other.text, 
        "vehicle_euro_type_id": selectedEuro_veh_type.vehicle_euro_type_id,
        "vehicle_euro_type_name": selectedEuro_veh_type.vehicle_euro_type_name,
        "vehicle_euro_type_other": vehicle_class_other.text,
        "notes": notes.text,
        "order_id": widget.order_detail != null ? widget.order_detail.id_order : null

      });
      print("---json data:${json_data}");
      TunnelModule.onBooking(json_data).then((value) {
        if(value == 200){
          Toast.show("Booking has proceed susscessfully", context);
          setState(() {
            selectedTunnel = null;
            selectedRoute = null;
            cross_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
            this._typeAheadController.text = "";
            selectedVeh_length = null;
            selectedVeh_type = null;
            selectedVeh_class_type = null;
            vehicle_class_other.text = "";
            selectedEuro_veh_type = null;
            notes.text = "";
          });
        }
      });
    }
    if(widget.index == 4){    //Euro
      TruckRoute truck_route;
      if(selected_route_list.length > 0){
        truck_route = selected_route_list[0];
      }
      var mrn_list = [];
      if(mrn_files.length > 0){
        for(int i = 0; i < mrn_files.length; i++){ 
          var mrn = {};
          mrn["code"] = euro_mrn.text;
          mrn["filename"] = "mrn" + (i + 1).toString() + "." + mrn_files[i].extension;
          File mrn_file = new File(mrn_files[i].path);
          List<int> fileBytes = mrn_file.readAsBytesSync();
          String base64File = base64Encode(fileBytes);
          mrn["data"] = base64File;
          mrn_list.add(mrn);
        }
        
      }
      var grm_list = [];
      
      if(grm_files.length > 0){
        for(int i = 0; i < grm_files.length; i++){ 
          var grm = {};
          grm["code"] = euro_grm.text;
          grm["filename"] = "grm" + (i + 1).toString() + "." + grm_files[i].extension;
          File grm_file = new File(grm_files[i].path);
          List<int> fileBytes = grm_file.readAsBytesSync();
          String base64File = base64Encode(fileBytes);
          grm["data"] = base64File;
          grm_list.add(grm);
        }
        
      }

      // print("--- file name:${mrn_list}");
      String json_data = jsonEncode({
        "PHPSESSID" : UserModule.user.sessId,
        "route" : selectedEuroRoute,
        "port_id_from": port_id_from,
        "port_id_to": port_id_to,
        "date" : euro_cross_date,
        "truck_num" : selected_truck_num,
        "truck_feature_category" : selectedVeh_length,
        "truck_type_name" : selectedVeh_type,
        "length" : euro_tunnel_meter.text,
        "notes" : euro_notes.text,
        // "route_id" : truck_route.route_id,
        // "interim_route_id" : truck_route.inter_route_id,
        // "company_id" : truck_route.company_id,
        // "company" : truck_route.company,
        // "departure" : truck_route.departure,
        // "arrival" : truck_route.arrival,
        // "description" : truck_route.description,
        // "price" : truck_route.price
        "loaded": empty_flag == true ? 1 : 0,
        "mrn": mrn_list,
        "grm": grm_list,
        "order_id": widget.order_detail != null ? widget.order_detail.id_order : null

      });
      // String output = jsonEncode(mrn_list);
      print("---json data:${json_data}");
      EuroModule.onBooking(json_data).then((value){
        if(value == 200){
          setState(() {
            Toast.show("Booking has proceed susscessfully", context);
            selectedEuroRoute = null;
            euro_cross_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
            this._typeAheadController.text = "";
            selectedVeh_length = null;
            selectedVeh_type = null;
            euro_tunnel_meter.text = "";
            euro_notes.text = "";
          });
        }
      });
    }
    if(widget.index == 7){    //bridge
      
      String json_data = jsonEncode({
        "PHPSESSID" : UserModule.user.sessId,
        "id_bridge": selectedBridge.id_bridge,
        "id_toll": selectedBridge.id_toll,
        "bridge_name" : selectedBridge.bridge_name,
        "bridge_other": bridge_other.text,
        "date": bridge_date,
        "id_country_from": selectedBridge.id_country_from,
        "country_from": selectedBridge.country_from,
        "id_country_to": selectedBridge.id_country_to,
        "country_to": selectedBridge.country_to,
        "network_length": selectedBridge.network_length,
        "operators": selectedBridge.operators,
        "vehicles": selectedBridge.vehicles,
        "truck_num" : selected_truck_num,
        "truck_feature_category" : selectedVeh_length,
        "truck_type_name" : selectedVeh_type,
        "vehicle_manufacturer_id": selected_manufacturer.vehicle_manufacturer_id,
        "vehicle_manufacturer_name": selected_manufacturer.vehicle_manufacturer_name,
        "vehicle_model": vehicle_model.text,
        "vehicle_color": vehicle_color.text,
        "id_country": selected_country.id_country,
        "country_name": selected_country.country_name,
        "euro_class_rating": selectedEuroClass,
        "notes": euro_notes.text,
        "order_id": widget.order_detail != null ? widget.order_detail.id_order : null

      });
      print("---json data:${json_data}");
      BridgeModule.onBooking(json_data).then((value){
        if(value == 200){
          setState(() {
            Toast.show("Booking has proceed susscessfully", context);
            selectedBridge = null;
            bridge_other.text = "";
            bridge_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
            this._typeAheadController.text = "";
            selectedVeh_length = null;
            selectedVeh_type = null;
            selected_manufacturer = null;
            vehicle_model.text = "";
            vehicle_color.text = "";
            selected_country = null;
            selectedEuroClass = "";
            euro_notes.text = "";
          });
        }
      });
    }
    if(widget.index == 2){    //train
      
      String port_name_from = selected_from.split(',')[0];
      String country_name_from = selected_from.split(' ')[1];
      int port_id_from; int country_id_from;
      if(port_name_from != null || port_name_from != ""){
        for(int i = 0; i < TrainModule.froms.length; i++){
          if(port_name_from == TrainModule.froms[i].port_name){
            port_id_from = TrainModule.froms[i].port_id;
            country_id_from = TrainModule.froms[i].country_id;
            break;
          }
        }
      }
      String port_name_to = selected_to.split(',')[0];
      String country_name_to = selected_to.split(' ')[1];
      int port_id_to; int country_id_to;
      if(port_name_to == null || port_name_to != ""){
        for(int i = 0; i < TrainModule.tos.length; i++){
          if(port_name_to == TrainModule.tos[i].port_name){
            port_id_to = TrainModule.tos[i].port_id;
            country_id_to = TrainModule.tos[i].country_id;
            break;
          }
        }
      }
      int truck_id;
      if(selected_truck_num != null || selected_truck_num == ""){
        for(int i = 0; i < VehicleModule.regnum_list.length; i++){
          if(selected_truck_num == VehicleModule.regnum_list[i].truck_num ){
            truck_id = VehicleModule.regnum_list[i].truck_id;
            break;
          }
        }
      }
      int truck_feature_id;
      if(selectedVeh_length != null || selectedVeh_length != ""){
        for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
          if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
            truck_feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
            break;
          }
        }
      }
      int truck_type_id;
      if(selectedVeh_type != null || selectedVeh_type != ""){
        for(int i = 0; i < VehicleModule.vehType_list.length; i++){
          if(selectedVeh_type == VehicleModule.vehType_list[i].name){
            truck_type_id = VehicleModule.vehType_list[i].type;
            break;
          }
        } 
      }
      TruckRoute truck_route;
      if(selected_route_list.length > 0){
        truck_route = selected_route_list[0];
      }
      String json_data = jsonEncode({
        "PHPSESSID" : UserModule.user.sessId,
        "port_id_from" : port_id_from,
        "port_name_from" : port_name_from,
        "country_id_from" : country_id_from,
        "country_name_from" : country_name_from,
        "port_id_to" : port_id_to,
        "port_name_to" : port_name_to,
        "country_id_to" : country_id_to,
        "country_name_to" : country_name_to,
        "date" : service_date,
        "truck_num" : selected_truck_num,
        "truck_id" : truck_id,
        "truck_feature_id" : truck_feature_id,
        "truck_feature_category" : selectedVeh_length,
        "truck_type_id" : truck_type_id,
        "truck_type_name" : selectedVeh_type,
        "length" : euro_tunnel_meter.text,
        "notes" : train_notes.text,
        "route_id" : truck_route.route_id,
        "interim_route_id" : truck_route.inter_route_id,
        "company_id" : truck_route.company_id,
        "company" : truck_route.company,
        "departure" : truck_route.departure,
        "arrival" : truck_route.arrival,
        "description" : truck_route.description,
        "price" : truck_route.price,
        "order_id": widget.order_detail != null ? widget.order_detail.id_order : null
      });
      print("tunnel_data:----------${json_data}");
      TrainModule.onBooking(json_data).then((value){
        if(value == 200){
          Toast.show("Booking has proceed susscessfully", context);
          setState(() {
            selected_from = null;
            selected_to = null;
            to_region.clear();
            this._typeAheadController.text = "";
            selectedVeh_length = null;
            selectedVeh_type = null;
            euro_tunnel_meter.text = "";
            service_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
          });
        }
      });
      
    }
    if(widget.index == 6){                      ///// Toll
      List<Map<String, dynamic>> send_data = [];
      if(toll_list.length > 0){
        for(int i = 0; i < toll_list.length; i++){
          if(toll_list[i].status == true){
            send_data.add(toll_list[i].toJson());
          }
        }
      }
      if(send_data.length > 0){
        await TollModule.onBooking(send_data).then((value){
          if(value != ""){
            Toast.show("Toll data sent", context);
          }
        });
      }
    }
    int order_id = 0;
    if(widget.order_detail != null){
      order_id = widget.order_detail.id_order;
    }
    else{
      order_id = null;
    }
    if(widget.index == 5){
      await TruckingModule.onBooking(selectedTruckingService.trucking_type_id, other_trucking.text, trucking_date, from_trucking.text, to_trucking.text, comment_trucking.text, order_id).then((value){
        if(value == "success"){
          Toast.show("Booking Trucking Service", context);
        }
      });
    }
  }

  List<String> getSuggestions(String search) {
    suggest_list = [];
    if(VehicleModule.regnum_list.length > 0){
      for(int i = 0; i < VehicleModule.regnum_list.length; i++){
        if(VehicleModule.regnum_list[i].truck_num.contains(search)){
          suggest_list.add(VehicleModule.regnum_list[i].truck_num);
        }
      }
    }
    return suggest_list;
  }
  List<String> getTrailerSuggestions(String search) {
    trailer_suggest_list = [];
    if(VehicleModule.regnum_list.length > 0){
      for(int i = 0; i < VehicleModule.regnum_list.length; i++){
        if(VehicleModule.regnum_list[i].truck_num.contains(search)){
          trailer_suggest_list.add(VehicleModule.regnum_list[i].truck_num);
        }
      }
    }
    return trailer_suggest_list;
  }
  void changeTruckState(Map<String, dynamic> json){
    if(VehicleModule.vehLength_list.length > 0){
      for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
        if(json["truck_feature_id"] == VehicleModule.vehLength_list[i].truck_feature_id){
          selectedVeh_length = VehicleModule.vehLength_list[i].truck_feature_category;
          veh_length_state = false;
          break;
        }
      }
    }
    if(VehicleModule.vehType_list.length > 0){
      for(int i = 0; i < VehicleModule.vehType_list.length; i++){
        if(json["truck_type_id"] == VehicleModule.vehType_list[i].type){
          selectedVeh_type = VehicleModule.vehType_list[i].name;
          veh_type_state = false;
          break;
        }
      }
    }
    euro_tunnel_meter.text = json["truck_length"];
    
  }
  void changeTrailerState(Map<String, dynamic> json){
    if(VehicleModule.vehLength_list.length > 0){
      for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
        if(json["truck_feature_id"] == VehicleModule.vehLength_list[i].truck_feature_id){
          trailer_selectedVeh_length = VehicleModule.vehLength_list[i].truck_feature_category;
          trailer_veh_length_state = false;
          break;
        }
      }
    }
    if(VehicleModule.vehType_list.length > 0){
      for(int i = 0; i < VehicleModule.vehType_list.length; i++){
        if(json["truck_type_id"] == VehicleModule.vehType_list[i].type){
          trailer_selectedVeh_type = VehicleModule.vehType_list[i].name;
          trailer_veh_type_state = false;
          break;
        }
      }
    }
    euro_tunnel_meter.text = json["truck_length"];
    
  }
  Future<void> findRoute() async {
    int port_id_from = 0;
    int port_id_to = 0;
    int truck_feature_id = 0;
    for(int i = 0; i < from_region.length; i++){
      if(selected_from == from_region[i]){
        port_id_from = TrainModule.froms[i].port_id;
        break;
      }
    }
    for(int i = 0; i < to_region.length; i++){
      if(selected_to == to_region[i]){
        port_id_to = TrainModule.tos[i].port_id;
        break;
      }
    }
    for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
      if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
        truck_feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
        break;
      }
    }
    await TrainModule.getRoutes(port_id_from, port_id_to, service_date, truck_feature_id).then((value){
      print("---available count:${TrainModule.route_list.length}");
    });
  }
  Future<void> findEuroTunnelRoute() async {
    
    if(selectedEuroRoute == "UK-FR"){
      port_id_from = 13;
      port_id_to = 12;
    }
    if(selectedEuroRoute == "FR-UK"){
      port_id_from = 12;
      port_id_to = 13;
    }
    for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
      if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
        truck_feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
        break;
      }
    }
    await EuroModule.getRoutes(port_id_from, port_id_to, euro_cross_date, truck_feature_id).then((value){
      print("---available count:${TrainModule.route_list.length}");
    });
  }
  Future<void> findFerryRoute() async {
    if(selected_ferry_from != null){
      int departure_id = selected_ferry_from.port_id;
      int arrival = selected_ferry_to.id;
      String travelDate = ferry_date;
      int feature_id = 0;
      for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
        if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
          feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
          break;
        }
      }
      await FerryModule.getFerryRoute(departure_id, arrival, travelDate, feature_id).then((value){
        print("---available ferry count:${FerryModule.ferry_route_list.length}");
      });
    }
  }
  Future<void> findLongBridgeRoute() async {
    int feature_id = 0;
    for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
      if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
        feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
        break;
      }
    }
    if(selected_longbridge_from == null){
      await LongBridgeModule.getLongBridgeRoutes(selected_longbridge_from.port_id, selected_longbridge_to.id,longbridge_date1, longbridge_date2, feature_id).then((value){

      });
    }
  }
  Future<void> findEnglishMessinaRoute() async {
    int feature_id = 0;
    if(selected_second_location != null){
      for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
        if(selectedVeh_length == VehicleModule.vehLength_list[i].truck_feature_category){
          feature_id = VehicleModule.vehLength_list[i].truck_feature_id;
          break;
        }
      }
      if(selected_english_messina == "English-channel"){
        await EnglishMessinaModule.getEnglishRoute(selected_second_location.fromId, selected_second_location.toId, enlgish_messina_date, feature_id).then((value){
          print("---available english count:${EnglishMessinaModule.english_messina_list.length}");
        });
      }
      else{
        await EnglishMessinaModule.getMessinaRoute(selected_second_location.fromId, selected_second_location.toId, enlgish_messina_date, feature_id).then((value){
          print("---available english count:${EnglishMessinaModule.english_messina_list.length}");
        });
      }
    }
  }

  Widget offsetPopup(ScreenSize screen, int index) {
    if(index == 2){
      findRoute();
      return PopupMenuButton<int>(
        onSelected: (value){
          setState(() {
            for(int i = 0; i < TrainModule.route_list.length; i++){
              if(value == TrainModule.route_list[i].route_id){
                selected_route_list.add(TrainModule.route_list[i]);
                break;
              }
            }
          });
        },
        itemBuilder: (context) =>[
          for(var route in TrainModule.route_list)
            PopupMenuItem(
              value: route.route_id,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(route.departure,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Arrival",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.arrival),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.price)
                        ],
                      ),
                    )
                  ],
                )
              )
            )
        ],
        icon: Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: new Align(alignment: Alignment.center, child: new Text(TrainModule.route_list != null && TrainModule.route_list.length > 0 ? "AVAILABLE ROUTES" : "UNAVAILABLE ROUTES", style: new TextStyle(fontSize: 16.0, color: Colors.white),),),
          ),
        );
    }
    if(index == 1){
      findLongBridgeRoute();
      return PopupMenuButton<int>(
        onSelected: (value){
          setState(() {
            for(int i = 0; i < LongBridgeModule.route_list.length; i++){
              if(value == LongBridgeModule.route_list[i].id_route){
                selected_longbridgeroute_list.add(LongBridgeModule.route_list[i]);
                break;
              }
            }
          });
        },
        itemBuilder: (context) =>[
          for(var route in LongBridgeModule.route_list)
            PopupMenuItem(
              value: route.id_route,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(route.departure,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Arrival",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.arrival),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.price)
                        ],
                      ),
                    )
                  ],
                )
              )
            )
        ],
        icon: Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: new Align(alignment: Alignment.center, child: new Text(LongBridgeModule.route_list != null && LongBridgeModule.route_list.length > 0 ? "AVAILABLE ROUTES" : "UNAVAILABLE ROUTES", style: new TextStyle(fontSize: 16.0, color: Colors.white),),),
          ),
        );
    }
    if(index == 4){
      findEuroTunnelRoute();
      return PopupMenuButton<int>(
        onSelected: (value){
          setState(() {
            for(int i = 0; i < EuroModule.route_list.length; i++){
              if(value == EuroModule.route_list[i].route_id){
                selected_route_list.add(EuroModule.route_list[i]);
                break;
              }
            }
          });
        },
        itemBuilder: (context) =>[
          for(var route in EuroModule.route_list)
            PopupMenuItem(
              value: route.route_id,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(route.departure,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Arrival",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.arrival),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.price)
                        ],
                      ),
                    )
                  ],
                )
              )
            )
        ],
        icon: Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: new Align(alignment: Alignment.center, child: new Text(EuroModule.route_list != null && EuroModule.route_list.length > 0 ? "AVAILABLE ROUTES" : "UNAVAILABLE ROUTES", style: new TextStyle(fontSize: 16.0, color: Colors.white),),),
          ),
        );
    }
    if(index == 0){
      findFerryRoute();
      return PopupMenuButton<int>(
        onSelected: (value){
          setState(() {
            for(int i = 0; i < FerryModule.ferry_route_list.length; i++){
              if(value == FerryModule.ferry_route_list[i].id_route){
                selected_ferry_route_list.add(FerryModule.ferry_route_list[i]);
                break;
              }
            }
          });
        },
        itemBuilder: (context) =>[
          for(var route in FerryModule.ferry_route_list)
            PopupMenuItem(
              value: route.id_route,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(route.departure,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Arrival",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.arrival),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.price)
                        ],
                      ),
                    )
                  ],
                )
              )
            )
        ],
        icon: Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: new Align(alignment: Alignment.center, child: new Text(FerryModule.ferry_route_list != null && FerryModule.ferry_route_list.length > 0 ? "AVAILABLE ROUTES" : "UNAVAILABLE ROUTES", style: new TextStyle(fontSize: 16.0, color: Colors.white),),),
          ),
        );
    }
    if(index == 5){
      findEnglishMessinaRoute();
      return PopupMenuButton<int>(
        onSelected: (value){
          setState(() {
            for(int i = 0; i < EnglishMessinaModule.english_messina_list.length; i++){
              if(value == EnglishMessinaModule.english_messina_list[i].id_route){
                selected_messina_route_list.add(EnglishMessinaModule.english_messina_list[i]);
                print("-----selected_messina_route_list:${selected_messina_route_list.length}");
                break;
              }
            }
          });
        },
        itemBuilder: (context) =>[
          for(var route in EnglishMessinaModule.english_messina_list)
            PopupMenuItem(
              value: route.id_route,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Departure", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(route.departure,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Arrival",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.arrival),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(route.price)
                        ],
                      ),
                    )
                  ],
                )
              )
            )
        ],
        icon: Container(
            width: double.infinity,
            height: 40,
            color: Colors.red,
            child: new Align(alignment: Alignment.center, child: new Text(EnglishMessinaModule.english_messina_list != null && EnglishMessinaModule.english_messina_list.length > 0 ? "AVAILABLE ROUTES" : "UNAVAILABLE ROUTES", style: new TextStyle(fontSize: 16.0, color: Colors.white),),),
          ),
        );
    }
    
  }
}

class Region {

  String label;
  String value;
  bool selected;

  Region ({
    this.label,
    this.value,
    this.selected
  });

  String get getLabel => label;
  set setLabel(String v){
    label = v;
  }

  String get getValue=> value;
  set setValue(String v){
    value = v;
  }

  bool get getSelected=> selected;
  set setSelected(bool v){
    selected = v;
  }


  factory Region.fromJson(Map<String, dynamic> json) {

    return new Region(
      label: json['label'],
      value: json['value'],
      selected: json['selected']??false,
    );
  }
}
