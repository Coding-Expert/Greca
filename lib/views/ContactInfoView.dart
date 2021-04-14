import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greca/helpers/ScreenSize.dart';

class ContactInfoView extends StatefulWidget {
  @override
  _ContactInfoViewState createState() => _ContactInfoViewState();
}

class _ContactInfoViewState extends State<ContactInfoView> {
  String TAG = "ContactInfoView ===>";

  TextEditingController inputFullname = new TextEditingController();
  TextEditingController inputEmail = new TextEditingController();
  TextEditingController inputTlp = new TextEditingController();
  TextEditingController inputSubject = new TextEditingController();
  TextEditingController inputMsg = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    double pLeft = 20.0;
    double pRight = 20.0;
    bool isPhone = true;
    if(getScreen.getWidth() > 1000){
      isPhone = false;
      pLeft = getScreen.getWidth()/3;
      pRight = getScreen.getWidth()/3;
      print("$TAG isPhone: ${isPhone} || ${getScreen.getWidth()} > 1000");
    }else{
      print("$TAG isPhone: ${isPhone} || ${getScreen.getWidth()} < 1000");
    }


    return Stack(
      children: [
        Material(
          child: _backgroundLogin(getScreen),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                width: getScreen.getWidth(),
                padding: EdgeInsets.only(top: (getScreen.getHeight()/8), bottom: 20.0, left: pLeft, right: pRight),
                child: Column(
                  children: [
                    Image.asset("assets/icons/logo.png"),
                    SizedBox(height: 40.0,),
                    //fullname
                    Container(
                      // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2):getScreen.getWidth(),
                      width: isPhone == true ? getScreen.getWidth():(getScreen.getWidth()/2),
                      height: 50.0,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2)/6 : (getScreen.getWidth()/2)/2,
                            width: isPhone ? (getScreen.getWidth()/2)/2 : (getScreen.getWidth()/2)/6,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Fullname: ", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                              ],
                            ),
                          ),
                          Container(
                            width: isPhone/*MediaQuery.of(context).orientation == Orientation.landscape*/ ? (getScreen.getWidth()/1.7):(getScreen.getWidth()/2)/2,
                            height: 50.0,
                            child: TextField(
                              controller: inputFullname,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white)),
                                  // hintText: 'type usesrname',
                                  // hintStyle: TextStyle(color: Colors.white),
                                  // labelText: 'Username',
                                  // labelStyle: TextStyle(color: Colors.white),
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.white,
                                  // ),
                                  prefixText: '',
                                  suffixStyle: const TextStyle(color: Colors.white)),
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //email
                    Container(
                      // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2):getScreen.getWidth(),
                      width: isPhone == true ? getScreen.getWidth():(getScreen.getWidth()/2),
                      height: 50.0,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2)/6 : (getScreen.getWidth()/2)/2,
                            width: isPhone ? (getScreen.getWidth()/2)/2 : (getScreen.getWidth()/2)/6,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Email: ", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                              ],
                            ),
                          ),
                          Container(
                            width: isPhone/*MediaQuery.of(context).orientation == Orientation.landscape*/ ? (getScreen.getWidth()/1.7):(getScreen.getWidth()/2)/2,
                            height: 50.0,
                            child: TextField(
                              controller: inputEmail,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white)),
                                  // hintText: 'type usesrname',
                                  // hintStyle: TextStyle(color: Colors.white),
                                  // labelText: 'Username',
                                  // labelStyle: TextStyle(color: Colors.white),
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.white,
                                  // ),
                                  prefixText: '',
                                  suffixStyle: const TextStyle(color: Colors.white)),
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //tlp
                    Container(
                      // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2):getScreen.getWidth(),
                      width: isPhone == true ? getScreen.getWidth():(getScreen.getWidth()/2),
                      height: 50.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2)/6 : (getScreen.getWidth()/2)/2,
                            width: isPhone ? (getScreen.getWidth()/2)/1.6 : (getScreen.getWidth()/2)/6,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Telephone: ", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                              ],
                            ),
                          ),
                          Container(
                            width: isPhone/*MediaQuery.of(context).orientation == Orientation.landscape*/ ? (getScreen.getWidth()/1.9):(getScreen.getWidth()/2)/2,
                            height: 50.0,
                            child: TextField(
                              controller: inputTlp,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white)),
                                  // hintText: 'type usesrname',
                                  // hintStyle: TextStyle(color: Colors.white),
                                  // labelText: 'Username',
                                  // labelStyle: TextStyle(color: Colors.white),
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.white,
                                  // ),
                                  prefixText: '',
                                  suffixStyle: const TextStyle(color: Colors.white)),
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //subject
                    Container(
                      // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2):getScreen.getWidth(),
                      width: isPhone == true ? getScreen.getWidth():(getScreen.getWidth()/2),
                      height: 50.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // width: MediaQuery.of(context).orientation == Orientation.landscape ? (getScreen.getWidth()/2)/6 : (getScreen.getWidth()/2)/2,
                            width: isPhone ? (getScreen.getWidth()/2)/2 : (getScreen.getWidth()/2)/6,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Subject: ", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                              ],
                            ),
                          ),
                          Container(
                            width: isPhone/*MediaQuery.of(context).orientation == Orientation.landscape*/ ? (getScreen.getWidth()/1.7):(getScreen.getWidth()/2)/2,
                            height: 50.0,
                            child: TextField(
                              controller: inputSubject,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(5.0),
                                  focusColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(color: Colors.white)),
                                  // hintText: 'type usesrname',
                                  // hintStyle: TextStyle(color: Colors.white),
                                  // labelText: 'Username',
                                  // labelStyle: TextStyle(color: Colors.white),
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.white,
                                  // ),
                                  prefixText: '',
                                  suffixStyle: const TextStyle(color: Colors.white)),
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Row(
                      children: [
                        Text("MESSAGE:", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      ],
                    ),
                    TextField(
                      minLines: 5,
                      maxLines: 8,
                      controller: inputMsg,
                      decoration: new InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                        focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          // hintText: 'type usesrname',
                          // hintStyle: TextStyle(color: Colors.white),
                          // labelText: 'Username',
                          // labelStyle: TextStyle(color: Colors.white),
                          // prefixIcon: const Icon(
                          //   Icons.person,
                          //   color: Colors.white,
                          // ),
                          prefixText: '',
                          suffixStyle: const TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
          ),
        ),
      ],
    );


  }//END Build

  Widget _backgroundLogin(ScreenSize getScreen){
    if(getScreen.getOrientation()==Orientation.landscape){
      print("$TAG SHOW TAB ==============");
      return Container(
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.fitWidth,),
      );
    }
    else{
      return Container(
        height: getScreen.getHeight(),
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.cover,),
      );
    }
  }

}
