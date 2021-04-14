import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:toast/toast.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatefulWidget {
  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  String TAG = "OrdersView ===>";

  TextEditingController inputSearchOrders = new TextEditingController();

  bool isTransaction = true;

  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "Date",
        value: "date",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Truck",
        value: "truck",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Route",
        value: "route",
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
        text: "Company",
        value: "company",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Booking Code",
        value: "bookingCode",
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

  List<Map<String, dynamic>> _generateData({int n: 10}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = List<Map<String, dynamic>>();
    var i = _source.length;
    print(i);
    for (var data in source) {
      temps.add({
        "date": i,
        "truck": "Customer $i",
        "route": "Day-$i",
        "depature": "${i}00",
        "arrival": "0${i}0",
        "company": "Product - P-${i}0",
        "bookingCode": "Greca.com - ${i}0",
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
    print("$TAG initState running...");
    _initData();
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
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (){},
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
                        onTap: (){},
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
                        onTap: (){},
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
                              Icon(Icons.insert_drive_file, color: Colors.white, size: 30.0,),
                              Text("Title", style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.white.withOpacity(1.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 20.0,),
                        child: TextField(
                          controller: inputSearchOrders,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white)),
                              hintText: 'type orders',
                              hintStyle: TextStyle(color: Colors.black),
                              labelText: 'Search orders',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              prefixText: ' ',
                              suffixStyle: const TextStyle(color: Colors.black)),
                        ),
                      ),
                      //rainbow status
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return _buildListOrder(context, index, screenSize, provider);
            },
            childCount: 10,
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
            provider.setIsSecondOrdersView = true;
            provider.setIsMainOrdersView = false;
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
                            color: Colors.green,
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
                      Text("B-Code-${index}", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                      SizedBox(height: 5.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey,size: 16.0,),
                          SizedBox(width: 5.0,),
                          Text("1${index}-12-2020", style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              /*
                //date
                Container(
                  padding: EdgeInsets.only(left: 12.0),
                  width: screenSize.getWidth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Date", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                      Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Company", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                      tick1(),
                      spacer(),
                      line(),
                      spacer(),
                      tick2(),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                */
              ],
            ),
          ),
        ),
      ),
    );
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
            provider.setIsSecondOrdersView = true;
            provider.setIsMainOrdersView = false;
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 3.0),
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
                      Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        height: 50.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Company", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                            Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                      tick1(),
                      spacer(),
                      line(),
                      spacer(),
                      tick2(),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
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
                          Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                            height: 50.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Company", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                                Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                                Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                                Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                                Text("xxx", style: TextStyle(fontSize: 18.0, color: Colors.black),),
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
                          tick1(),
                          spacer(),
                          line(),
                          spacer(),
                          tick2(),
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
                    headers: _headers,
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


  Widget tick1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.directions_car,color: Colors.blue,),
        Text("Truck:", style: TextStyle(fontSize: 14.0),),
        Text("GB-2929-YY", style: TextStyle(fontSize: 16.0),),
      ],
    );
  }

  Widget tick2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on,color: Colors.red,),
        Text("Route:", style: TextStyle(fontSize: 14.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
        Text("Greek to India", style: TextStyle(fontSize: 16.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
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

}
