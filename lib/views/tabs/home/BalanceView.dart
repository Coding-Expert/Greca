import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/models/BalanceModel.dart';
import 'package:greca/models/Charge.dart';
import 'package:greca/models/TransInfo.dart';
import 'package:greca/models/Transaction.dart';
import 'package:greca/module/balance_module.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:share/share.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:toast/toast.dart';

class BalanceView extends StatefulWidget {

  bool order;

  BalanceView({
    Key key,
    this.order
  }) : super(key: key);
  @override
  _BalanceViewState createState() => _BalanceViewState();
}

class _BalanceViewState extends State<BalanceView> {
  String TAG = "BalanceView ===>";

  DateTime currentBackPressTime;

  bool isTransaction = true;
  bool isShowOption = false;

  String idTable = "";
  String customerTable = "";
  String inv_filename;
  Permission permission1 = Permission.WriteExternalStorage;
  bool downloading = false;

  List<BalanceModel> listBalance = new List();

  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "ID",
        value: "id",
        show: false,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Customer",
        value: "customer",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Invoice Date",
        value: "invoiceDate",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Report Number",
        value: "reportNumber",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Reference Number",
        value: "refNumber",
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
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Description",
        value: "description",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Truck",
        value: "truck",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Route",
        value: "route",
        show: true,
        flex: 2,
        sortable: false,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Booking Code",
        value: "bookingCode",
        show: true,
        sortable: false,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Debit",
        value: "debit",
        show: true,
        sortable: false,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Credit",
        value: "credit",
        show: true,
        sortable: false,
        textAlign: TextAlign.center),
  ];

  bool _isSearch = false;
  List<Map<String, dynamic>> _source = List<Map<String, dynamic>>();
  List<Map<String, dynamic>> _selecteds = List<Map<String, dynamic>>();
  String _selectableKey = "id";

  String _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  Transaction transaction; 
  Charge charge;
  bool trans_loading = false;

  List<Map<String, dynamic>> _generateData({int n: 10}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = List<Map<String, dynamic>>();
    var i = _source.length;
    print(i);
    for (var data in source) {
      temps.add({
        "id": i,
        "customer": "Customer $i",
        "invoiceDate": "Invoice date-$i",
        "reportNumber": "${i}00",
        "refNumber": "0${i}0",
        "company": "Greca.com - ${i}0",
        "description": "Product - P-${i}0",
        "truck": "Telsa Truck - T-${i}0",
        "route": "Route - R-${i}0",
        "bookingCode": "CODE-${i}0",
        "debit": "Debit${i}0",
        "credit": "Credit-${i}0",
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
    trans_loading = true;
    getChargeList();
    // _initData();
  }
  Future<void> getChargeList() async {
    await BalanceModule.getTransaction().then((value){
      if(value != null){
        transaction = BalanceModule.transaction;
        charge = BalanceModule.charge;
      }
      setState(() {
        trans_loading = false;
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
            // resizeToAvoidBottomPadding: false,
            body: Stack(
              children: [
                if(provider.getIsShowOrderView)MainOrdersView(getScreen, provider),
                if(!provider.getIsShowOrderView)
                  downloading == true ? loadingWidget(getScreen, provider) :
                  SecondOrdersView(getScreen, provider),
                // if(isShowOption)OptionView(getScreen, provider),
                //Menu
                if(getScreen.getWidth()>790)Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.only(top: 33.0, left: 10.0,),
                    child: Row(
                      children: [
                        Container(
                          width: 120.0,
                          height: 40.0,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: BorderSide(color: Colors.white)),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.print),
                                SizedBox(width: 8.0,),
                                Text(
                                  "Print",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 120.0,
                          height: 40.0,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                side: BorderSide(color: Colors.white)),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.insert_drive_file),
                                SizedBox(width: 8.0,),
                                Text(
                                  "title",
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget OptionView(ScreenSize screenSize, MyProvider provider){
    return Container(
      width: screenSize.getWidth(),
      height: screenSize.getHeight(),
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          width: screenSize.getWidth()/3,
          height: screenSize.getHeight()/2,
          color: Colors.white,
          child: RaisedButton(
            onPressed: (){
              setState(() {
                isShowOption = false;
                idTable = "";
                customerTable = "";
              });
            },
            child: Text("Close for\nID:$idTable, Name:$customerTable"),
          ),
        ),
      ),
    );
  }
  Widget loadingWidget(ScreenSize getScreen, MyProvider provider) {
    return Container(
      child: new Stack(
        children: [
          SecondOrdersView(getScreen, provider),
          new Positioned(
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
            top: MediaQuery.of(context).size.height / 2 - 100,
            left: MediaQuery.of(context).size.width / 2,
          )
          
        ],
      ),
    );
  }

  Widget MainOrdersView(ScreenSize screenSize, MyProvider provider){
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(top: 35.0, bottom: 70.0),
        color: Colors.lightBlueAccent,
        width: screenSize.getWidth(),
        height: screenSize.getHeight(),
        child: Column(
          children: [
            Image.asset("assets/icons/logo.png", height: 60.0,),
            SizedBox(height: 20.0,),
            Container(
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    height: 40.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.white,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          "YEAR",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 20.0,),
                  // Text("CUSTOMER", style: TextStyle(fontSize: 20.0, color: Colors.white),),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  //Based on Transactions
                  Container(
                    width: screenSize.getWidth()/2,
                    height: screenSize.getWidth() > 1000 ? 50.0: 70.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        // if(!isTransaction){
                          setState(() {
                            isTransaction = true;
                            // return;
                          });
                        // }
                      },
                      child: Text(
                        "Based on Transactions",
                        style: TextStyle(
                          fontSize: isTransaction == true ? 22.0 : 18.0,
                          color: isTransaction == true ? Colors.white : Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  //Based on Charges
                  Container(
                    width: screenSize.getWidth()/2,
                    height: screenSize.getWidth() > 1000 ? 50.0: 70.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.white)),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        // if(isTransaction){
                          setState(() {
                            isTransaction = false;
                            // return;
                          });
                        // }
                      },
                      child: Text(
                        "Based on Charges",
                        style: TextStyle(
                          fontSize: isTransaction == false ? 22.0 : 18.0,
                          color: isTransaction == false ? Colors.white : Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if(screenSize.getWidth()<750)
              trans_loading == true ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red)
              ) :
              Expanded(
                child:ListView.builder(
                    itemCount: isTransaction == true ? transaction.trans_info.length : charge.charge_info.length,
                    itemBuilder: (context, index){
                      return _buildList(context, index, screenSize, provider);
                    }
                ),
            ),
            if(screenSize.getWidth()>750)Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 1.0),
                color: Colors.white,
                height: screenSize.getHeight(),
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
    );
  }

  Widget _buildList(BuildContext context, int index, ScreenSize screenSize, MyProvider provider){
    if(screenSize.getWidth() > 1000){
      return Container(
        // color: Colors.white.withOpacity(0.3),
          padding: EdgeInsets.only(left: screenSize.getWidth()/3, right: screenSize.getWidth()/3),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                provider.setIsShowOrderView = false;
              },
              child: Container(
                height: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 4,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ],
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/user.png")
                          )
                      ),
                    ),
                    SizedBox(width: 30.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Name $index", style: TextStyle(color: Colors.white, fontSize: 23.0),),
                        Text("User ID $index", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }
    else{
      return Container(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                provider.isTransShow = isTransaction;
                if(isTransaction){
                  provider.seleted_transaction = transaction.trans_info[index];
                }
                else{
                  provider.selected_charge = charge.charge_info[index];
                }
                provider.setIsShowOrderView = false;
              },
              child: Container(
                height: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 4,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ],
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/user.png")
                          )
                      ),
                    ),
                    SizedBox(width: 30.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isTransaction == true ? transaction.trans_info[index].client != null ? transaction.trans_info[index].client : "xxx" : charge.charge_info[index].client != null ? charge.charge_info[index].client : "xxx", style: TextStyle(color: Colors.white, fontSize: 23.0),),
                        Text(isTransaction == true ? transaction.trans_info[index].ref_number != null ? transaction.trans_info[index].ref_number : "xxx" : charge.charge_info[index].ref_number != null ? charge.charge_info[index].ref_number : "xxx", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }

  }

  Widget SecondOrdersView(ScreenSize screenSize, MyProvider provider){
    return Container(
        color: Colors.lightBlueAccent,
        height: screenSize.getHeight(),
        width: screenSize.getWidth(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 35.0),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/icons/logo.svg",
                color: Colors.lightBlueAccent,
              ),
              SizedBox(height: 20.0,),
              Container(
                child: screenSize.getWidth() > 1000
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Customer: ", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                    Text(isTransaction == true ? provider.seleted_transaction.client : provider.selected_charge.client, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                  ],
                )
                    : Container(),
              ),
              if(screenSize.getWidth()>790)_buildTabView(screenSize, provider),
              if(screenSize.getWidth()<790)_buildPhoneView(screenSize, provider)
            ],
          ),
        )
    );
  }

  Widget _buildTabView(ScreenSize screenSize, MyProvider provider){
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 30.0),
            height: screenSize.getHeight(),
            width: screenSize.getWidth()/5,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide( //                   <--- left side
                  color: Colors.white.withOpacity(0.3),
                  width: 3.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      provider.setIsShowOrderView = true;
                    },
                    child: Container(
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 30.0,),
                          SizedBox(width: 10.0,),
                          Text("Back", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide( //                   <--- left side
                            color: Colors.white.withOpacity(0.3),
                            width: 3.0,
                          ),
                        ),
                      ),
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.print, color: Colors.white, size: 30.0,),
                          SizedBox(width: 10.0,),
                          Text("Print", style: TextStyle(color: Colors.white, fontSize: 20.0),),
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
                          top: BorderSide( //                   <--- left side
                            color: Colors.white.withOpacity(0.3),
                            width: 3.0,
                          ),
                        ),
                      ),
                      height: 60.0,
                      width: screenSize.getWidth()/3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.insert_drive_file, color: Colors.white, size: 30.0,),
                          SizedBox(width: 10.0,),
                          Text("Title", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenSize.getHeight(),
            width: screenSize.getWidth()-(screenSize.getWidth()/5),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneView(ScreenSize screenSize, MyProvider provider){
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    provider.setIsShowOrderView = true;
                  },
                  child: Container(
                    height: 60.0,
                    width: screenSize.getWidth()/3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 30.0,),
                        Text("Back", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    provider.setIsShowOrderView = true;
                    downloadFile(provider);
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
                     onShare(provider);
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
                        Icon(Icons.insert_drive_file, color: Colors.white, size: 30.0,),
                        Text("Invoice", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 1.9),
            padding: EdgeInsets.all(8.0),
            width: screenSize.getWidth(),
            height: screenSize.getHeight(),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.0,),
                //customer and company
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Customer", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                    Text(isTransaction == true ? provider.seleted_transaction.client : provider.selected_charge.client, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text("Company: ", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6))),
                        ),
                        Flexible(
                          child: Text(isTransaction == true ? provider.seleted_transaction.company != null ? provider.seleted_transaction.company : "xxx" : provider.selected_charge.company != null ? provider.selected_charge.company : "xxx", style: TextStyle(fontSize:15.0, fontWeight: FontWeight.bold, color: Colors.black),maxLines:2,textAlign: TextAlign.center),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 18.0,),
                //invoice date
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 33.0,),
                    SizedBox(width: 8.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Invoice Date:", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                        Text("In-Date 2020-12-12", style: TextStyle(fontSize: 17.0, color: Colors.black),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 13.0,),
                //report number
                Row(
                  children: [
                    Icon(Icons.article, size: 33.0,),
                    SizedBox(width: 8.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Report Number:", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                        Text(isTransaction == true ? provider.seleted_transaction.report_number != null ? provider.seleted_transaction.report_number: "xxx" : provider.selected_charge.report_number != null ? provider.selected_charge.report_number : "xxx", style: TextStyle(fontSize: 17.0, color: Colors.black),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 13.0,),
                //dept date
                Row(
                  children: [
                    Icon(Icons.calendar_today_sharp, size: 33.0,),
                    SizedBox(width: 8.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Departure Date:", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                        Text(isTransaction == true ? provider.seleted_transaction.ddate : provider.selected_charge.ddate, style: TextStyle(fontSize: 17.0, color: Colors.black),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 13.0,),
                //Debit and credit
                Row(
                  children: [
                    Container(
                      width: (screenSize.getWidth()/2)-10,
                      height: 50.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Debit", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                          Text(isTransaction == true ? provider.seleted_transaction.debit : provider.selected_charge.debit, style: TextStyle(fontSize: 17.0, color: Colors.black),),
                        ],
                      ),
                    ),
                    Container(
                      width: (screenSize.getWidth()/2)-10,
                      height: 50.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Credit", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                          Text(isTransaction == true ? provider.seleted_transaction.credit : provider.selected_charge.credit, style: TextStyle(fontSize: 17.0, color: Colors.black),),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.0,),
                //Ref and Booking code
                Row(
                  children: [
                    Container(
                      width: (screenSize.getWidth()/2)-10,
                      height: 50.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ref Number", style: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.6)),),
                          Text(isTransaction == true ? provider.seleted_transaction.ref_number != null ? provider.seleted_transaction.ref_number : "xxx" : provider.selected_charge.ref_number != null ? provider.selected_charge.ref_number : "xxx", style: TextStyle(fontSize: 17.0, color: Colors.black),),
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
                          Text(isTransaction == true ? provider.seleted_transaction.booking_code != null ? provider.seleted_transaction.booking_code : "xxx" : "xxx", style: TextStyle(fontSize: 17.0, color: Colors.black),),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    tick1(),
                    spacer(),
                    line(),
                    spacer(),
                    tick2(),
                  ],
                ),
                SizedBox(height: 15.0,),
                Container(
                  width: screenSize.getWidth(),
                  margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent.withOpacity(0.5))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Descriptions:", style: TextStyle(color: Colors.red.withOpacity(0.6), fontSize: 17.0),),
                      Text(isTransaction == true ? provider.seleted_transaction.description != null ? provider.seleted_transaction.description : "xxx" : provider.selected_charge.description != null ? provider.selected_charge.description : "xxx", style: TextStyle(color: Colors.black, fontSize: 17.0),),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onShare(MyProvider provider) {
    String inv_filename;
    if(isTransaction == true){
      inv_filename = provider.seleted_transaction.inv_filename;
      
    }
    else{
      inv_filename = provider.selected_charge.inv_filename;
    }
    if(inv_filename == null){
      Toast.show("No invoice file", context);
      return;
    }
    Share.shareFiles([
        inv_filename                
      ]
    );
    
  }

  Future<void> downloadFile(MyProvider provider) async {
    String inv_filename;
    if(isTransaction == true){
      inv_filename = provider.seleted_transaction.inv_filename;
      
    }
    else{
      inv_filename = provider.selected_charge.inv_filename;
    }
    if(inv_filename == null){
      Toast.show("No invoice file", context);
      return;
    }
    String file_name = inv_filename.substring(inv_filename.lastIndexOf("/") + 1, inv_filename.length);
    String file_extension = inv_filename.substring(inv_filename.lastIndexOf(".") + 1, inv_filename.length);
    Dio dio = Dio();
    bool checkPermission1 =
        await SimplePermissions.checkPermission(permission1);
    // print(checkPermission1);
    if (checkPermission1 == false) {
      await SimplePermissions.requestPermission(permission1);
      checkPermission1 = await SimplePermissions.checkPermission(permission1);
    }
    if (checkPermission1 == true) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(inv_filename, dirloc + file_name + "." + file_extension,
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
          });
          
        });
      } catch (e) {
        print(e);
      }
      setState(() {
        downloading = false;
        print("----download complete------");
      });
    } else {
      
    }
  }

  Widget tick1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.directions_car,color: Colors.blue,),
        Text("Truck:", style: TextStyle(fontSize: 14.0),),
        Text("GB-2929-YY", style: TextStyle(fontSize: 15.0),),
      ],
    );
  }

  Widget tick2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on,color: Colors.red,),
        Text("Route:", style: TextStyle(fontSize: 14.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
        Text("Greek to India", style: TextStyle(fontSize: 15.0),overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
      ],
    );
    return Icon(Icons.location_on,color: Colors.red,);
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
