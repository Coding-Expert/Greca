import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/views/HomeView.dart';

class AssistentView extends StatefulWidget {
  @override
  _AssistentViewState createState() => _AssistentViewState();
}

class _AssistentViewState extends State<AssistentView> {
  String TAG = "AssistentView ===>";

  @override
  void initState() {
    super.initState();
    print("$TAG initState running..");
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    return WillPopScope(
        onWillPop: (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
                (Route<dynamic> route) => false,
          );
        },
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: getScreen.getWidth()/12, bottom: 50.0),
            child: Container(
              width: getScreen.getWidth(),
              child: Column(
                children: [
                  Image.asset("assets/icons/logo.png"),
                  SizedBox(height: 40.0,),
                  Container(
                    height: getScreen.getHeight()/4,
                    width: getScreen.getOrientation()==Orientation.landscape ? getScreen.getWidth()/3 : getScreen.getWidth(),
                    padding: EdgeInsets.all(7.0),
                    child: Stack(
                      children: [
                        Container(
                            height: (getScreen.getHeight()/4)/1.3,
                            width: getScreen.getOrientation()==Orientation.landscape ? getScreen.getWidth()/3 : getScreen.getWidth(),
                            margin: EdgeInsets.only(top: (getScreen.getHeight()/4)/2.8),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/bubble_white.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: Text("Need help more?", style: TextStyle(fontSize: 19.9),),
                            )
                        ),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Container(
                        //       width: 100.0,
                        //       height: 100.0,
                        //       padding: EdgeInsets.all(10.0),
                        //       margin: EdgeInsets.only(bottom: (getScreen.getHeight()/4)/2),
                        //       decoration:  BoxDecoration(
                        //           color: Colors.transparent,
                        //           // shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //               fit: BoxFit.fill,
                        //               image:  AssetImage("assets/icons/customer_service.png")
                        //           )
                        //       )
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10.0,),
                  Container(
                    height: getScreen.getHeight()/4,
                    width: getScreen.getOrientation()==Orientation.landscape ? getScreen.getWidth()/3 : getScreen.getWidth(),
                    padding: EdgeInsets.all(7.0),
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                            height: (getScreen.getHeight()/4)/1.3,
                            width: getScreen.getOrientation()==Orientation.landscape ? getScreen.getWidth()/3 : getScreen.getWidth(),
                            margin: EdgeInsets.only(top: (getScreen.getHeight()/4)/2.8),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/bubble_black.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("You want to service Ferry again?", style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                    SizedBox(height: 8.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 40.0,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Colors.green)),
                                            color: Colors.transparent,
                                            textColor: Colors.green,
                                            padding: EdgeInsets.all(8.0),
                                            onPressed: () {
                                              _onClick(true);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0,),
                                        Container(
                                          width: 100.0,
                                          height: 40.0,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                                side: BorderSide(color: Colors.red)),
                                            color: Colors.transparent,
                                            textColor: Colors.red,
                                            padding: EdgeInsets.all(8.0),
                                            onPressed: () {
                                              _onClick(false);
                                            },
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                            )
                        ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Container(
                        //       width: 80.0,
                        //       height: 80.0,
                        //       padding: EdgeInsets.all(10.0),
                        //       margin: EdgeInsets.only(bottom: (getScreen.getHeight()/4)/3, left: 15.0),
                        //       decoration:  BoxDecoration(
                        //           color: Colors.transparent,
                        //           // shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //               fit: BoxFit.fill,
                        //               image:  AssetImage("assets/icons/history_service.png")
                        //           )
                        //       )
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  _onClick(bool status){
    if(status){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
            (Route<dynamic> route) => false,
      );
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
            (Route<dynamic> route) => false,
      );
    }
  }

}
