import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/models/PriceFrom.dart';
import 'package:greca/models/PriceTo.dart';
import 'package:greca/models/Prices.dart';
import 'package:greca/models/VehicleLength.dart';
import 'package:greca/module/price_module.dart';
import 'package:greca/module/vehicle_module.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class PricesView extends StatefulWidget {
  bool order;

  PricesView({
    Key key,
    this.order
  }) : super(key: key);
  @override
  _PricesViewState createState() => _PricesViewState();
}

class _PricesViewState extends State<PricesView> {
  String TAG = "PricesView ===>";

  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "Shipping",
        value: "shipping",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Company",
        value: "company",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Day",
        value: "day",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Depature",
        value: "depature",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Arrival",
        value: "arrival",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Description",
        value: "description",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Price",
        value: "price",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
  ];

  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  bool isShowOption = false;
  String idTable = "";
  String customerTable = "";
  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  List<PriceFrom> from_list = [];
  bool from_flag = false;
  PriceFrom selected_priceFrom;
  List<PriceTo> to_list = [];
  bool to_flag = false;
  PriceTo selected_priceTo;
  String service_date;
  bool vehicles_length_flag = false;
  List<VehicleLength> vehicles_length = [];
  VehicleLength selectedVeh_length;
  List<Prices> specific_price_list = [];
  bool specific_flag = false;
  List<Prices> price_list = [];


  List<Map<String, dynamic>> _generateData({int n: 10}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = List<Map<String, dynamic>>();
    var i = _source.length;
    print(i);
    for (var data in source) {
      temps.add({
        "shipping": i,
        "company": "company $i",
        "day": "Day-$i",
        "depature": "${i}00",
        "arrival": "0${i}0",
        "description": "Product - P-${i}0",
        "price": "Greca.com - ${i}0",
      });
      i++;
    }
    return temps;
  }

  _initData() async {
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _source.addAll(_generateData(n: 10));
      if(mounted){
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("$TAG initState runnning...");
    service_date = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
    getPriceFrom();
    _initData();
  }
  Future<void> getPriceFrom() async {
    from_flag = true;
    await PriceModule.getFromList().then((value) async {
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          from_list.add(value[i]);
        }
      }
      setState(() {
        from_flag = false;
        vehicles_length_flag = true;
      });
      await VehicleModule.getVeh_Length().then((value){
      setState(() {
        if(VehicleModule.vehLength_list.length > 0){
          for(int i = 0; i < VehicleModule.vehLength_list.length; i++){
            vehicles_length.add(VehicleModule.vehLength_list[i]);
          }
        }
        vehicles_length_flag = false;
      });
    });
    });
  }

  Future<void> getToList(int port_id) async {
    to_flag = true;
    await PriceModule.getToList(port_id).then((value){
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          to_list.add(value[i]);
        }
      }
      setState(() {
        to_flag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = new ScreenSize(context);
    return ChangeNotifierProvider<MyProvider>(
      create: (context)=>MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, provider, child){
          return Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            body: Stack(
              children: [
                if(getScreen.getWidth()<750)_buildPhoneView(getScreen, provider),
                if(provider.getIsShowPriceView)Container(
                  height: getScreen.getHeight(),
                  color: Colors.lightBlueAccent,
                  child: _priceViewDetail(getScreen, provider),
                ),
                //back home
                // if(provider.getIsShowPriceView)Align(
                //   alignment: Alignment.topCenter,
                //   child: Container(
                //     padding: EdgeInsets.only(top: getScreen.getHeight()/5, right: 10.0),
                //     child: Container(
                //       width: 120.0,
                //       height: 40.0,
                //       child: FlatButton(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(0.0),
                //             side: BorderSide(color: Colors.white)),
                //         color: getScreen.getOrientation()==Orientation.landscape ?  Colors.black.withOpacity(0.4):Colors.black.withOpacity(0.4),
                //         textColor: Colors.white,
                //         padding: EdgeInsets.all(8.0),
                //         onPressed: () {
                //           provider.setIsShowPriceView = false;
                //         },
                //         child: Text(
                //           "Back",
                //           style: TextStyle(
                //             fontSize: 18.0,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                if(getScreen.getWidth()>799)_buildTabView(getScreen, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneView(ScreenSize screenSize, MyProvider provider){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 35.0, bottom: 70.0),
        color: Colors.lightBlueAccent,
        width: screenSize.getWidth(),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              color: Colors.lightBlueAccent,
            ),
            SizedBox(height: 20.0,),
            //from
            Container(
                width: screenSize.getWidth(),
                margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                // padding: const EdgeInsets.all(6.0),
                // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text("From:", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                    ),
                    SizedBox(width: 8.0,),
                    from_flag == true ? CircularProgressIndicator()
                    :Expanded(
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
                          value: selected_priceFrom,
                          onChanged: (newValue) {
                            setState(() {
                              selected_priceFrom = newValue;
                              getToList(selected_priceFrom.port_id);
                            });
                          },
                          items: from_list.map((from) {
                            return DropdownMenuItem(
                              child: new Text(from.port_name),
                              value: from,
                            );
                          }).toList(), 
                          
                        )
                      )
                    )
                  ],
                )
            ),
            SizedBox(height: 20.0,),
            //to
            Container(
                width: screenSize.getWidth(),
                margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text("To:", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                    ),
                    SizedBox(width: 8.0,),
                    to_flag == true ? CircularProgressIndicator()
                    : Expanded(
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
                          value: selected_priceTo,
                          onChanged: (newValue) {
                            setState(() {
                              selected_priceTo = newValue;
                            });
                          },
                          items: to_list.map((to) {
                            return DropdownMenuItem(
                              child: new Text(to.name),
                              value: to,
                            );
                          }).toList(), 
                          
                        )
                      )
                    )
                  ],
                )
            ),
            SizedBox(height: 20.0,),
            //services
            Container(
                width: screenSize.getWidth(),
                margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text("Date of Services", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                    ),
                    SizedBox(width: 8.0,),
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
                    SizedBox(width: 8.0,),
                    Text(service_date ,style: TextStyle(color: Colors.white, fontSize: 19)),
                  ],
                )
            ),
            SizedBox(height: 20.0,),
            //length
            Container(
              width: screenSize.getWidth(),
              margin: const EdgeInsets.only(left: 9.0, right: 9.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    child: Text("Vehicle Length", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                  ),
                  SizedBox(width: 8.0,),
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
                            child: new Text(veh_length.truck_feature_category),
                            value: veh_length,
                          );
                        }).toList(), 
                        
                      )
                    ),
                  ),
                ],
              )
            ),
            SizedBox(height: 50.0,),
            //specific
            Container(
              width: screenSize.getWidth(),
              margin: const EdgeInsets.only(left: 9.0, right: 9.0),
              height: 40.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.teal)),
                textColor: Colors.white,
                color: Colors.teal,
                padding: EdgeInsets.all(8.0),
                onPressed: () async {
                  setState(() {
                    specific_flag = true;
                  });
                  await PriceModule.specificPriceList(selected_priceFrom.port_id , selected_priceTo.id, service_date, selectedVeh_length.truck_feature_id).then((value){
                    setState(() {
                      if(value.length > 0){
                        for(int i = 0; i < value.length; i++){
                          specific_price_list.add(value[i]);
                        }
                      }
                      specific_flag = false;
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.find_in_page),
                    SizedBox(width: 8.0,),
                    Text(
                      "Show prices for specific days",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            specific_price_list.length > 0 ? 
            Container(
              width: screenSize.getWidth(),
              margin: const EdgeInsets.only(left: 9.0, right: 9.0),
              height: 200,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      for(var price in specific_price_list)
                        ListTile(
                          title: Text(price.company + " " + price.price + " " + price.day + " " + price.departure, style: TextStyle(color: Colors.white)),
                          // trailing: IconButton(
                          //   icon: Icon(
                          //     Icons.delete,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () {
                          //     // setState(() {
                          //       // selected_route_list.remove(route);
                          //     // });
                          //   }),
                        )
                    ],
                  )
                ),
              ),
            ): Container(child: Text('no list'),),
            //for all
            Container(
              width: screenSize.getWidth(),
              margin: const EdgeInsets.only(left: 9.0, right: 9.0),
              height: 40.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.teal)),
                textColor: Colors.white,
                color: Colors.teal,
                padding: EdgeInsets.all(8.0),
                onPressed: () async {
                  price_list = [];
                  await PriceModule.priceList(selected_priceFrom.port_id , selected_priceTo.id, selectedVeh_length.truck_feature_id).then((value){
                    if(value.length > 0){
                      for(int i = 0; i < value.length; i++){
                        price_list.add(value[i]);
                      }
                    }
                    setState(() {
                      
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0,),
                    Text(
                      "Show prices for all days",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.0,),
            price_list.length > 0 ? 
            Container(
              width: screenSize.getWidth(),
              margin: const EdgeInsets.only(left: 9.0, right: 9.0),
              height: 200,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      for(var price in price_list)
                        GestureDetector(
                          onTap: (){
                            provider.detail_price = price;
                            provider.setIsShowPriceView = true;
                          },
                          child: ListTile(
                            title: Text(price.company + " " + price.price + " " + price.day + " " + price.departure, style: TextStyle(color: Colors.white)),
                            // trailing: IconButton(
                            //   icon: Icon(
                            //     Icons.delete,
                            //     color: Colors.white,
                            //   ),
                            // )
                          )
                        )
                    ],
                  )
                ),
              ),
            ): Container(child: Text('no list'),),
            //for available
            // Container(
            //   width: (screenSize.getWidth())-80,
            //   height: 40.0,
            //   child: FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(0.0),
            //         side: BorderSide(color: Colors.teal)),
            //     textColor: Colors.teal,
            //     color: Colors.white,
            //     padding: EdgeInsets.all(8.0),
            //     onPressed: () {
            //       provider.setIsShowPriceView = true;
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.check_circle),
            //         SizedBox(width: 8.0,),
            //         Text(
            //           "Available Routes",
            //           style: TextStyle(
            //             fontSize: 18.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _priceViewDetail(ScreenSize screenSize, MyProvider provider){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 35.0, bottom: 70.0),
        color: Colors.lightBlueAccent,
        width: screenSize.getWidth(),
        //height: screenSize.getHeight(),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              color: Colors.lightBlueAccent,
            ),
            SizedBox(height: 20.0,),
            //Back
            Container(
              padding: EdgeInsets.only(top: 0.0),
              child: Container(
                width: 120.0,
                height: 40.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.white)),
                  color: screenSize.getOrientation()==Orientation.landscape ?  Colors.black.withOpacity(0.4):Colors.black.withOpacity(0.4),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  onPressed: () {
                    provider.setIsShowPriceView = false;
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            //Detail
            Container(
              width: screenSize.getWidth(),
              color: Colors.white.withOpacity(0.5),
              margin: EdgeInsets.only(top: 22.0),
              padding: EdgeInsets.only(top: 17.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Available Routes", style: TextStyle(color: Colors.black, fontSize: 25.0),),
                  SizedBox(height: 30.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shipping Company", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.company, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Day", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.day, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Departure", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.departure, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Arrival", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.arrival, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Descriptions", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.description, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    width: screenSize.getWidth(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        Text(provider.detail_price.price, style: TextStyle(color: Colors.black, fontSize: 25.0),),
                      ],
                    ),
                  ),
                  SizedBox(height: 45.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView(ScreenSize screenSize, MyProvider provider){
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(top: 35.0, bottom: 70.0),
        color: Colors.lightBlueAccent,
        width: screenSize.getWidth(),
        height: screenSize.getHeight(),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/logo.svg",
              color: Colors.lightBlueAccent,
            ),
            SizedBox(height: 27.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              width: screenSize.getWidth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //from
                  Container(
                      width: screenSize.getWidth()/3,
                      margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.flag, color: Colors.white,),
                          SizedBox(width: 8.0,),
                          Text("From", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                        ],
                      )
                  ),
                  //to
                  Container(
                      width: screenSize.getWidth()/3,
                      margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: Colors.white,),
                          SizedBox(width: 8.0,),
                          Text("To", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                        ],
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              width: screenSize.getWidth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //services
                  Container(
                      width: screenSize.getWidth()/3,
                      margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.home_repair_service_rounded, color: Colors.white,),
                          SizedBox(width: 8.0,),
                          Text("Date of Services", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                        ],
                      )
                  ),
                  //length
                  Container(
                      width: screenSize.getWidth()/3,
                      margin: const EdgeInsets.only(left: 9.0, right: 9.0),
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.car_repair, color: Colors.white,),
                          SizedBox(width: 8.0,),
                          Text("Vehicle Length", style: TextStyle(color: Colors.white, fontSize: 19.0),),
                        ],
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 35.0,),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              width: screenSize.getWidth(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //specific
                  Container(
                    width: screenSize.getWidth()/3,
                    height: 40.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.teal)),
                      textColor: Colors.white,
                      color: Colors.teal,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.find_in_page),
                          SizedBox(width: 8.0,),
                          Text(
                            "Show prices for specific days",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  //for all
                  Container(
                    width: screenSize.getWidth()/3,
                    height: 40.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.teal)),
                      textColor: Colors.white,
                      color: Colors.teal,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 8.0,),
                          Text(
                            "Show prices for all days",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            //for available
            Container(
              width: (screenSize.getWidth())-80,
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white,),
                  SizedBox(width: 8.0,),
                  Text(
                    "Available Routes",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0,),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 1.0),
                color: Colors.white,
                height: screenSize.getHeight(),
                width: screenSize.getWidth(),
                child: ResponsiveDatatable(
                  headers: _headers,
                  source: _source,
                  selecteds: _selecteds,
                  autoHeight: false,
                  onTabRow: (data) {
                    print("$TAG onTabRow: ID:${data['id']} - Customer:${data['customer']}");
                    setState(() {
                      isShowOption = true;
                      idTable = data['id'].toString();
                      customerTable = data['customer'];
                    });
                  },
                  onSort: (value) {
                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      if (_sortAscending) {
                        _source.sort((a, b) =>
                            b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                      }
                      else {
                        _source.sort((a, b) =>
                            a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                      }
                    });
                  },
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
