import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/views/tabs/ServicesView.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String TAG = "DashboardView ===>";

  // bool showServiceView = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    print("$TAG initState  running");
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
      child: Consumer<MyProvider>(
        builder: (context, provider, child){
          print("$TAG show provider dashboard: ${provider.getIsShowServiceView}");
          return Stack(
            children: [
              Material(
                child: _backgroundLogin(getScreen),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  color: Colors.transparent,
                  width: getScreen.getWidth(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/logo.svg",
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(height: 40.0,),
                      Text("We commit ourselves to making your customer experience as effortless as possible by handling-in the most "
                          "personal way-cargo your safely and on time.",
                        style: TextStyle(color: Colors.white, fontSize: getScreen.getOrientation()==Orientation.landscape?30.0:16.0),
                        textAlign: TextAlign.center,),
                      if(getScreen.getOrientation()==Orientation.landscape)SizedBox(height: 0.0,),
                      if(getScreen.getOrientation()==Orientation.portrait)SizedBox(height: 30.0,),
                      Container(
                        margin: EdgeInsets.only(left: getScreen.getOrientation()==Orientation.landscape?10.0:3.0, right: getScreen.getOrientation()==Orientation.landscape?10.0:3.0),
                        child: _gridMenu(getScreen, provider),
                      )
                    ],
                  ),
                ),
              ),
              if(provider.getIsShowServiceView)ServicesView(index: _index,)
            ],
          );
        },
      ),
    );
  }//END Build

  Widget _backgroundLogin(ScreenSize getScreen){
    if(getScreen.getOrientation()==Orientation.landscape){
      return Container(
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.fitWidth,),
      );
    }else{
      return Container(
        height: getScreen.getHeight(),
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.cover,),
      );
    }
  }

  Widget _gridMenu(ScreenSize getScreen, MyProvider provider){
    double runSpacing = 4;
    double spacing = 50;
    int listSize = 8;
    int columns = 3;
    var w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) / columns;
    bool potrait = true;
    if(getScreen.getOrientation()==Orientation.landscape){
      potrait = false;
      columns = 4;
      w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) / columns;
    }

    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: List.generate(listSize, (index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (){
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (context) => ServicesView(index: index,)),
              // );

                provider.setIsShowServiceView = true;
                setState(() {
                  _index = index;
                });

            },
            child: _gridItems(index, w, potrait),
          ),
        );
      }),
    );
  }

  Widget _gridItems(int index, double w, bool potrait){
    if(!potrait){
      w = w-100;
      print("$TAG Landscape: $w");
    }
    if(index==0){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true ? "assets/icons/01ferry.png":"assets/icons/ferry.png"),
            SizedBox(height: 0.0,),
            Text("Ferry || Booking", style: TextStyle(fontSize: 18.0, color: Colors.white),)
          ],
        ),
      );
    }
    if(index==1){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true ? "assets/icons/05bridges.png":"assets/icons/bridges.png"),
            SizedBox(height: 0.0,),
            Text("LongBridge || Booking", style: TextStyle(fontSize: 18.0, color: Colors.white), textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==2){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true ? "assets/icons/02train.png":"assets/icons/train.png"),
            SizedBox(height: 0.0,),
            Text("Train || Booking", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==3){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true ?"assets/icons/03tunnels.png":"assets/icons/tunnels.png"),
            SizedBox(height: 0.0,),
            Text("Tunnel || Pass", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==4){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true ?"assets/icons/03tunnels.png":"assets/icons/tunnels.png"),
            SizedBox(height: 0.0,),
            Text("Eurotunnel || Pass", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==5){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true?"assets/icons/07trucking.png":"assets/icons/trucking.png"),
            SizedBox(height: 0.0,),
            Text("Trucking || Services", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==6){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true?"assets/icons/06tolls.png":"assets/icons/tolls.png"),
            SizedBox(height: 0.0,),
            Text("Toll || Pass", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
    if(index==7){
      return Container(
        height: w,
        width: w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(potrait==true?"assets/icons/06tolls.png":"assets/icons/tolls.png"),
            SizedBox(height: 0.0,),
            Text("Bridge || Pass", style: TextStyle(fontSize: 18.0, color: Colors.white),textAlign: TextAlign.center,)
          ],
        ),
      );
    }
  }

}
