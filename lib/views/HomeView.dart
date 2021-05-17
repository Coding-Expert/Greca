import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greca/models/OrderDetail.dart';
import 'package:toast/toast.dart';
import 'package:greca/models/User.dart';
import 'package:greca/module/user_module.dart';
import 'package:greca/views/ContactInfoView.dart';
import 'package:greca/views/tabs/home/BalanceView.dart';
import 'package:greca/views/tabs/home/DashboardView.dart';
import 'package:greca/views/tabs/home/OrdersView.dart';
import 'package:greca/views/tabs/home/PricesView.dart';
import 'package:greca/views/tabs/home/ProfileView.dart';

class HomeView extends StatefulWidget {

  bool last_order;
  OrderDetail orderDetail;

  HomeView({
    Key key,
    this.last_order,
    this.orderDetail
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String TAG = "HomeView ===>";

  DateTime currentBackPressTime;
  int currentTabIndex = 3;

  List<Widget> tabs = [];
    // OrdersView(order: widget.last_order),
    // PricesView(order: widget.last_order),
    // BalanceView(order: widget.last_order),
    // ProfileView(order: widget.last_order),
    // DashboardView(order: widget.last_order),


  @override
  void initState() {
    super.initState();
    tabs.add(OrdersView());
    tabs.add(PricesView());
    tabs.add(BalanceView());
    // tabs.add(ProfileView());
    tabs.add(DashboardView(orderDetail: widget.orderDetail));
    print("$TAG initState running...");
  }

  @override
  void dispose() {
    super.dispose();
  }

  onTapped(int index) {
    
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("$TAG SIZE WIDTH: ${MediaQuery.of(context).size.width}");
    print("current_user----------:${UserModule.user.sessId}");
    if(MediaQuery.of(context).size.width<750){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    return WillPopScope(
      onWillPop: (){
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Toast.show("Press again to close app", context);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey,
          onTap: onTapped,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey.withOpacity(0.6),
          selectedFontSize: 15.0,
          currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Image.asset("assets/icons/list_2.png", height: 35.0, width: 35.0,),
              title: Text("Orders", style: TextStyle(fontSize: 14.0),),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Image.asset("assets/icons/pricelist2.png", height: 35.0, width: 35.0,),
              title: Text("Prices", style: TextStyle(fontSize: 14.0),),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Image.asset("assets/icons/Blanace.png", height: 35.0, width: 35.0,),
              title: Text("Balance", style: TextStyle(fontSize: 14.0),),
            ),
            // BottomNavigationBarItem(
            //   backgroundColor: Colors.black,
            //   icon: Image.asset("assets/icons/profile.png", height: 35.0, width: 35.0,),
            //   title: Text("Profile", style: TextStyle(fontSize: 14.0),),
            // ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Image.asset("assets/icons/Home.png", height:35.0, width: 35.0,),
              title: Text("Home", style: TextStyle(fontSize: 14.0),),
            )
          ],
        ),
      ),
    );

  }
}
