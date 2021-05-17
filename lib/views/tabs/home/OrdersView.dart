import 'dart:io';
import 'dart:math';

import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greca/models/OrderModel.dart';
import 'package:greca/module/orders_module.dart';
import 'package:greca/views/HomeView.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:share/share.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:toast/toast.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OrdersView extends StatefulWidget {
  bool order;

  OrdersView({
    Key key,
    this.order
  }) : super(key: key);
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  String TAG = "OrdersView ===>";

  TextEditingController inputSearchOrders = new TextEditingController();
  String get search => inputSearchOrders.text;
  bool isTransaction = true;

  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  bool isShowOption = false;
  String idTable = "";
  String customerTable = "";
  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  List<Order> order_list = [];
  List<Order> current_list = [];
  bool order_loading = false;
  bool pending_filter = false;
  bool process_filter = false;
  bool cancelled_filter = false;
  bool finished_filter = false;
  bool nonshow_filter = false;
  Permission permission1 = Permission.WriteExternalStorage;

  @override
  void initState() {
    super.initState();
    print("$TAG initState running...");
    order_loading = true;
    getOrderList();
    
    // _initData();
  }
  Future<void> getOrderList() async {
    await OrdersModule.getOrderList().then((value){
      order_list = [];
      if(value.length > 0){
        for(int i = 0; i < value.length; i++){
          order_list.add(value[i]);
          current_list.add(value[i]);
        }
      }
      setState(() {
        order_loading = false;
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = new ScreenSize(context);
    print("$TAG SIZE: ${screenSize.getOrientation()}");
    print("$TAG SIZE: ${screenSize.getWidth()}");
    return ChangeNotifierProvider<MyProvider>(
      create: (context)=>MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, provider, child){
          if(screenSize.getWidth()<750){
            if(provider.getIsMainOrdersView){
              return _MainOrder(screenSize, provider);
            }
            if(provider.getIsSecondOrdersView){
              return _SecondOrder(screenSize, provider);
            }
          }
          else{
            return _buildTabView(screenSize, provider);
          }
        },
      ),
      // child: Consumer<MyProvider>(
      //   builder: (context, provider, child){
      //     return Container();
      //     return Stack(
      //       children: [
      //         if(provider.getIsShowOrderView)MainOrdersView(getScreen, provider),
      //         if(!provider.getIsShowOrderView)SecondOrdersView(getScreen, provider)
      //       ],
      //     );
      //   },
      // ),
    );
  }

  Widget _MainOrder(ScreenSize screenSize, MyProvider provider){
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: 35.0),
            color: Colors.lightBlueAccent,
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/logo.svg",
                  color: Colors.lightBlueAccent,
                ),
                SizedBox(height: 15.0,),
                
                Container(
                  color: Colors.white.withOpacity(1.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0,),
                        child: TextField(
                          controller: inputSearchOrders,
                          // style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.black)),
                              hintText: 'search',
                              hintStyle: TextStyle(color: Colors.black),
                              labelText: 'Search orders',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              prefixText: ' ',
                              suffixStyle: const TextStyle(color: Colors.black)),
                          onChanged: (order) => _updateState(),
                        ),
                      ),
                      //rainbow status
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //pending
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pending_filter = true;
                                  process_filter = false;
                                  cancelled_filter = false;
                                  finished_filter = false;
                                  nonshow_filter = false;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      if(order_list[i].order_status != 1 && order_list[i].order_status != 3 && order_list[i].order_status != 4 && order_list[i].order_status != 7){
                                        current_list.add(order_list[i]);
                                       
                                      }
                                    }
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("Pending", style: TextStyle(color: pending_filter == true ? Colors.yellow : Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                            //in proccess
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pending_filter = false;
                                  process_filter = true;
                                  cancelled_filter = false;
                                  finished_filter = false;
                                  nonshow_filter = false;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      if(order_list[i].order_status == 1){
                                        current_list.add(order_list[i]);
                                      }
                                    }
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightGreenAccent,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("In Proccess", style: TextStyle(color: process_filter == true ? Colors.lightGreenAccent : Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                            //cancelled
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pending_filter = false;
                                  process_filter = false;
                                  cancelled_filter = true;
                                  finished_filter = false;
                                  nonshow_filter = false;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      if(order_list[i].order_status == 3){
                                        current_list.add(order_list[i]);
                                      }
                                    }
                                  }
                                });
                              },
                              child:Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("Cancelled", style: TextStyle(color: cancelled_filter == true ? Colors.redAccent : Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                            //finished
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pending_filter = false;
                                  process_filter = false;
                                  cancelled_filter = false;
                                  finished_filter = true;
                                  nonshow_filter = false;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      if(order_list[i].order_status == 4){
                                        current_list.add(order_list[i]);
                                      }
                                    }
                                  }
                                });
                              },
                              child:Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("Finished", style: TextStyle(color: finished_filter == true ? Colors.lightBlueAccent : Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                            //Non show
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pending_filter = false;
                                  process_filter = false;
                                  cancelled_filter = false;
                                  finished_filter = false;
                                  nonshow_filter = true;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      if(order_list[i].order_status == 7){
                                        current_list.add(order_list[i]);
                                      }
                                    }
                                  }
                                });
                              },
                              child:Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("Non Show", style: TextStyle(color: nonshow_filter == true ? Colors.blue : Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pending_filter = false;
                                  process_filter = false;
                                  cancelled_filter = false;
                                  finished_filter = false;
                                  nonshow_filter = false;
                                  if(order_list.length > 0){
                                    current_list = [];
                                    for(int i = 0; i < order_list.length; i++) {
                                      current_list.add(order_list[i]);
                                    }
                                  }
                                });
                              },
                              child:Column(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text(" All ", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                                ],
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return order_loading == true ? CircularProgressIndicator() :
                    _buildListOrder(context, index, screenSize, provider);
            },
            childCount: current_list.length,
          ),
        ),
      ],
    );
  }

  Widget _buildListOrder(BuildContext context, int index, ScreenSize screenSize, MyProvider provider){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide( //                   <--- left side
            color: Colors.lightBlueAccent.withOpacity(0.8),
            width: 1.0,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            // provider.setIsSecondOrdersView = true;
            // provider.setIsMainOrdersView = false;
            // provider.selected_order = order_list[index];
            provider.getOrderDetail(current_list[index].id_port_order);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 3.0),
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15.0, right: 15.0, bottom: 15.0, left: 25.0),
                  child:  Column(
                    children: [
                      Container(
                        height: 20.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                          color: current_list[index].order_status == 1 ? Colors.lightGreenAccent :
                                  current_list[index].order_status == 3 ? Colors.redAccent :
                                  current_list[index].order_status == 4 ? Colors.lightBlueAccent :
                                  current_list[index].order_status == 7 ? Colors.blue :
                                  Colors.yellow,
                          shape: BoxShape.circle
                        ),
                      ),
                      // SizedBox(height: 2.0,),
                      // Text("Proccess", style: TextStyle(color: Colors.black, fontSize: 12.0),),
                    ],
                  ),
                ),
                SizedBox(width: 10.0,),
                Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(current_list[index].route_name, style: TextStyle(color: Colors.black, fontSize: 18.0)),
                      SizedBox(height: 5.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey,size: 16.0,),
                          SizedBox(width: 5.0,),
                          Text(current_list[index].travel_date, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14.0)),
                          SizedBox(width: 5.0,),
                          Text("Vehicle Number: ", style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14.0)),
                          SizedBox(width: 5.0,),
                          Text(current_list[index].truck, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14.0)),
                          
                          
                        ],
                      ),
                    ],
                  ),
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
    
  }

  Widget _SecondOrder(ScreenSize screenSize, MyProvider provider){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 33.0),
        child: Container(
          width: screenSize.getWidth(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      provider.setIsSecondOrdersView = false;
                      provider.setIsMainOrdersView = true;
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
            Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView(orderDetail: provider.order_detail,)),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 30.0,),
                          Text("Edit", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      onCreatePDF(provider);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide( //                   <--- left side
                            color: Colors.white.withOpacity(0.3),
                            width: 3.0,
                          ),
                        ),
                      ),
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.print, color: Colors.white, size: 30.0,),
                          Text("Print", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      String booking_code = provider.order_detail.booking_code;
                      if(provider.order_detail.booking_code == null){
                        booking_code = "";
                      }
                      Share.share("Route Name: " + provider.order_detail.route_name + "\n"
                        + "Travel Date: " + provider.order_detail.travel_date + "\n"
                        + "Company: " + provider.order_detail.company + "\n"
                        + "Booking Code: " + booking_code + "\n"
                        + "Arrival: " + provider.order_detail.arrival + "\n"
                        + "Departure: " + provider.order_detail.departure + "\n"
                        + "Truck: " + provider.order_detail.truck
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide( //                   <--- left side
                            color: Colors.white.withOpacity(0.3),
                            width: 3.0,
                          ),
                        ),
                      ),
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: Colors.white, size: 30.0,),
                          Text("Share", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 3.0, top: 15.0),
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    //date
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      width: screenSize.getWidth(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Date", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                          Text(provider.order_detail.travel_date != null ? provider.order_detail.travel_date : "xxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //Company and booking
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      width: screenSize.getWidth(),
                      child: Row(
                        children: [
                          Container(
                            width: (screenSize.getWidth()/2)-10,
                            height: 70.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Company", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                                Text(provider.order_detail.company != null ? provider.order_detail.company : "xxx", style: TextStyle(fontSize: 15.0, color: Colors.black,), maxLines: 2, textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Container(
                            width: (screenSize.getWidth()/2)-10,
                            height: 50.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Booking Code", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                                Text(provider.order_detail.booking_code != null ? provider.order_detail.booking_code : "xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //arrival and depature
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      width: screenSize.getWidth(),
                      child: Row(
                        children: [
                          Container(
                            width: (screenSize.getWidth()/2)-10,
                            height: 50.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Arrival", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                                Text(provider.order_detail.arrival != null ? provider.order_detail.arrival : "xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
                              ],
                            ),
                          ),
                          Container(
                            width: (screenSize.getWidth()/2)-10,
                            height: 50.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Depature", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                                Text(provider.order_detail.departure != null ? provider.order_detail.departure : "xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //truck and route
                    Container(
                      padding: EdgeInsets.only(left: 12.0),
                      width: screenSize.getWidth(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          tick1(provider),
                          spacer(),
                          line(),
                          spacer(),
                          tick2(provider),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabView(ScreenSize screenSize, MyProvider provider){
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 33.0),
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: screenSize.getWidth(),
          height: screenSize.getHeight(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                color: Colors.lightBlueAccent,
              ),
              SizedBox(height: 35.0,),
              Container(
                color: Colors.white,
                width: screenSize.getWidth(),
                child: Column(
                  children: [
                    Text("ORDERS", style: TextStyle(color: Colors.lightBlue, fontSize: 29.0, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10.0,),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //pending
                          Column(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Text("Pending", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(width: 25.0,),
                          //in proccess
                          Column(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.lightGreenAccent,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Text("In Proccess", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(width: 25.0,),
                          //cancelled
                          Column(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Text("Cancelled", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(width: 25.0,),
                          //finished
                          Column(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Text("Finished", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                            ],
                          ),
                          SizedBox(width: 25.0,),
                          //Non show
                          Column(
                            children: [
                              Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Text("Non Show", style: TextStyle(color: Colors.black, fontSize: 14.0),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              height: 60.0,
                              width: screenSize.getWidth()/5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, color: Colors.black, size: 30.0,),
                                  Text("Edit", style: TextStyle(color: Colors.black),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide( //                   <--- left side
                                    color: Colors.black.withOpacity(0.4),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              height: 60.0,
                              width: screenSize.getWidth()/5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.print, color: Colors.black, size: 30.0,),
                                  Text("Print", style: TextStyle(color: Colors.black),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (){},
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide( //                   <--- left side
                                    color: Colors.black.withOpacity(0.4),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              height: 60.0,
                              width: screenSize.getWidth()/5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.remove_red_eye, color: Colors.black, size: 30.0,),
                                  Text("View", style: TextStyle(color: Colors.black),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 1.0, /*bottom: 120.0*/),
                  padding: EdgeInsets.only(bottom: 110.0),
                  color: Colors.white,
                  width: screenSize.getWidth(),
                  child: ResponsiveDatatable(
                    // headers: _headers,
                    source: _source,
                    selecteds: _selecteds,
                    //showSelect: _showSelect,
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
      ),
    );
  }


  Widget tick1(MyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.directions_car,color: Colors.blue,),
        Text("Truck:", style: TextStyle(fontSize: 14.0),),
        Text(provider.order_detail.truck != null ? provider.order_detail.truck : "xxx", style: TextStyle(fontSize: 16.0),),
      ],
    );
  }

  Widget tick2(MyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on,color: Colors.red,),
        Text("Route:", style: TextStyle(fontSize: 14.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
        Text(provider.order_detail.route_name != null ? provider.order_detail.route_name : "xxx", style: TextStyle(fontSize: 16.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
      ],
    );
  }

  Widget spacer() {
    return Container(
      width: 5.0,
    );
  }

  Widget line() {
    return Row(
      children: [
        Icon(Icons.arrow_forward_ios, color: Colors.green.withOpacity(0.5),),
        Icon(Icons.arrow_forward_ios, color: Colors.green.withOpacity(0.8),),
        Icon(Icons.arrow_forward_ios, color: Colors.green,),
      ],
    );
    return Container(
      color: Colors.blue,
      height: 5.0,
      width: (MediaQuery.of(context).size.width)/4,
    );
  }

  void _updateState() {
    print('search: $search');
    if(search != null && search.isNotEmpty){
      if(order_list.length > 0){
        current_list = [];
        for(int i = 0; i < order_list.length; i++) {
          if(order_list[i].route_name.contains(search.toUpperCase()) || order_list[i].route_name.contains(search.toLowerCase())){
            current_list.add(order_list[i]);
          }
          if(order_list[i].truck.contains(search.toUpperCase()) || order_list[i].truck.contains(search.toLowerCase())){
            current_list.add(order_list[i]);
          }
          if(order_list[i].price.contains(search.toUpperCase()) || order_list[i].price.contains(search.toLowerCase())){
            current_list.add(order_list[i]);
          }
        }
      }
      setState(() {
      });
    }
    else {
      current_list = [];
      if(order_list.length > 0) {
        for(int i = 0; i < order_list.length; i++){
          current_list.add(order_list[i]);
        }
      }
      setState(() {
      });
    }
  }

  Future<void> onCreatePDF(MyProvider provider) async {
    PdfDocument document = PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
                                pen: PdfPen(PdfColor(142,170,219,255)));
    List<int> fontData = await _readData('fonts/GoogleSans-Bold.ttf');
    PdfFont contentFont = PdfTrueTypeFont(fontData, 9);
    PdfFont headerFont = PdfTrueTypeFont(fontData, 30);
    PdfFont footerFont = PdfTrueTypeFont(fontData, 18);

    final PdfGrid grid = _getGrid(contentFont, provider);
    final PdfLayoutResult result = _drawerHeader(page, pageSize, grid, contentFont, headerFont, footerFont);
    _drawGrid(page, grid, result, contentFont);
    // _drawFooter(page, pageSize, contentFont);
    // final List<int> bytes = document.save();
    // print("----document byte:${bytes.length}");
    await downloadPDF(document);
    document.dispose();
  }
  Future<void> downloadPDF(PdfDocument document) async {
    bool checkPermission1 = false;
    if(Platform.isAndroid){
      checkPermission1 = await SimplePermissions.checkPermission(permission1);
      if (checkPermission1 == false) {
        await SimplePermissions.requestPermission(permission1);
        checkPermission1 = await SimplePermissions.checkPermission(permission1);
      }
    }
    
    String dirloc = "";
    if (Platform.isAndroid) {
      if (checkPermission1 == true) {
        dirloc = "/sdcard/download/";
      }
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path + "/";
    }
    try {
      FileUtils.mkdir([dirloc]);
      final file = File(dirloc + "orders.pdf");
      final List<int> bytes = document.save();
      file.writeAsBytes(bytes);
      if(bytes.length > 0){
        Toast.show("Document was created ", context);
      }
    } catch (e) {
      print(e);
    }
  }

  PdfLayoutResult _drawerHeader(PdfPage page, Size pageSize, PdfGrid grid, PdfFont contentFont, PdfFont headerFont, PdfFont footerFont){
    page.graphics.drawRectangle(brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
                                bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString('Truck', headerFont, 
                              brush: PdfBrushes.white, 
                              bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
                              format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle)
                              );
    page.graphics.drawRectangle(bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
                                brush: PdfSolidBrush(PdfColor(65, 104, 205)));
    // page.graphics.drawString('' + _getTotalAmount(grid).toString(), footerFont, 
    //                           bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
    //                           brush: PdfBrushes.white,
    //                           format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle)  
    //                         );
    page.graphics.drawString('', footerFont, 
                              bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
                              brush: PdfBrushes.white,
                              format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle)  
                            );
    //Draw string.
    page.graphics.drawString('', contentFont,
                              brush: PdfBrushes.white,
                              bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
                              format: PdfStringFormat(
                              alignment: PdfTextAlignment.center,
                              lineAlignment: PdfVerticalAlignment.bottom)
                            );
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate: ' +
                                  format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address = 'Bill To: \r\n\r\nAbraham Swearegin, \r\n\r\nUnited States, California, San Mateo, \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136';
    PdfTextElement(text: "", font: contentFont)
                  .draw(
                    page: page,
                    bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
                    contentSize.width + 30, pageSize.height - 120)
                  );
    return PdfTextElement(text: "", font: contentFont)
                  .draw(
                    page: page,
                    bounds: Rect.fromLTWH(30, 120,
                    pageSize.width - (contentSize.width + 30), pageSize.height - 120)
                  );
  }

  PdfGrid _getGrid(PdfFont contentFont, MyProvider provider) {
    //Create a PDF grid.
    final PdfGrid grid = PdfGrid();
    //Specify the column count to the grid.
    grid.columns.add(count: 7);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style.
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Date';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Company';
    headerRow.cells[2].value = 'Booking Code';
    headerRow.cells[3].value = 'Arrival';
    headerRow.cells[4].value = 'Departure';
    headerRow.cells[5].value = 'Truck';
    headerRow.cells[6].value = 'Route';
    _addProducts(provider.order_detail.travel_date, provider.order_detail.company, provider.order_detail.booking_code, provider.order_detail.arrival, provider.order_detail.departure, provider.order_detail.truck,provider.order_detail.route_name, grid);
    // _addProducts('CA-1098', 'AWC Logo Cap', 8.99, 2, 17.98, grid);
    // _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    // _addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    // _addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    // _addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    // _addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    final PdfPen whitePen = PdfPen(PdfColor.empty, width: 0.5);
    PdfBorders borders = PdfBorders();
    borders.all = PdfPen(PdfColor(142, 179, 219), width: 0.5);
    grid.rows.applyStyle(PdfGridCellStyle(borders: borders));
    grid.columns[1].width = 150;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      headerRow.cells[i].style.borders.all = whitePen;
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      if (i % 2 == 0) {
        row.style.backgroundBrush = PdfSolidBrush(PdfColor(217, 226, 243));
      }
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    //Set font
    grid.style.font = contentFont;
    return grid;
  }

  void _addProducts(String date, String company, String booking_code, String arrival, String departure, String truck, String route,PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = date;
    row.cells[1].value = company;
    if(booking_code == null){
      row.cells[2].value = 'xxx';
    }
    else{
      row.cells[2].value = booking_code;
    }
    
    // row.cells[2].value = price.toString();
    row.cells[3].value = arrival;
    row.cells[4].value = departure;
    row.cells[5].value = truck;
    row.cells[6].value = route;
  }
  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value;
      total += double.parse(value);
    }
    return total;
  }

  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result, PdfFont contentFont) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));
    // Draw grand total.
    // page.graphics.drawString('Grand Total', contentFont,
    //                         bounds: Rect.fromLTWH(
    //                         quantityCellBounds.left,
    //                         result.bounds.bottom + 10,
    //                         quantityCellBounds.width,
    //                         quantityCellBounds.height)
    //                       );
    page.graphics.drawString('', contentFont,
                            bounds: Rect.fromLTWH(
                            quantityCellBounds.left,
                            result.bounds.bottom + 10,
                            quantityCellBounds.width,
                            quantityCellBounds.height)
                          );
    // page.graphics.drawString(_getTotalAmount(grid).toString(), contentFont,
    //                           bounds: Rect.fromLTWH(
    //                           totalPriceCellBounds.left,
    //                           result.bounds.bottom + 10,
    //                           totalPriceCellBounds.width,
    //                           totalPriceCellBounds.height)
    //                       );
    page.graphics.drawString('', contentFont,
                              bounds: Rect.fromLTWH(
                              totalPriceCellBounds.left,
                              result.bounds.bottom + 10,
                              totalPriceCellBounds.width,
                              totalPriceCellBounds.height)
                          );
  }

  void _drawFooter(PdfPage page, Size pageSize, PdfFont contentFont) {
    final PdfPen linePen = PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line.
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),Offset(pageSize.width, pageSize.height - 100));
    const String footerContent = '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
    //Added 30 as a margin for the layout.
    page.graphics.drawString(footerContent, contentFont,
                            format: PdfStringFormat(alignment: PdfTextAlignment.right),
                            bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0)
                          );
  }

  Future<List<int>> _readData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

}
