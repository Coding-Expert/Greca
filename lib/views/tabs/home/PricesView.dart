import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';

class PricesView extends StatefulWidget {
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
    _initData();
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
            SizedBox(height: 20.0,),
            //to
            Container(
                width: screenSize.getWidth(),
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
            ),
            SizedBox(height: 20.0,),
            //services
            Container(
                width: screenSize.getWidth(),
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
            SizedBox(height: 20.0,),
            //length
            Container(
                width: screenSize.getWidth(),
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
            SizedBox(height: 50.0,),
            //specific
            Container(
              width: (screenSize.getWidth())-80,
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
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            //for all
            Container(
              width: (screenSize.getWidth())-80,
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
            SizedBox(height: 50.0,),
            //for available
            Container(
              width: (screenSize.getWidth())-80,
              height: 40.0,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: Colors.teal)),
                textColor: Colors.teal,
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  provider.setIsShowPriceView = true;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8.0,),
                    Text(
                      "Available Routes",
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
                        Text("xxxx", style: TextStyle(color: Colors.black, fontSize: 25.0),),
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
