import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:greca/connections/PostApi.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/models/User.dart';
import 'package:greca/module/user_module.dart';
import 'package:greca/views/AssistentView.dart';
import 'package:greca/views/HomeView.dart';
import 'package:greca/views/shared/AlertInfo.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String TAG = "LoginView ===>";

  TextEditingController inputUserName = new TextEditingController();
  TextEditingController inputPassword = new TextEditingController();

  bool isLoading = false;

  AlertInfo _alertInfo = AlertInfo();

  PostApi _postApi = new PostApi();


  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    double pLeft = 20.0;
    double pRight = 20.0;
    if(getScreen.getOrientation()==Orientation.landscape){
      pLeft = getScreen.getWidth()/3;
      pRight = getScreen.getWidth()/3;
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
                padding: EdgeInsets.only(top: (getScreen.getHeight()/5), bottom: 20.0, left: pLeft, right: pRight),
                child: Column(
                  children: [
                    //Image.asset("assets/icons/logo.png"),
                    SvgPicture.asset(
                      "assets/icons/logo.svg",
                      color: Colors.lightBlueAccent,
                    ),
                    SizedBox(height: 40.0,),
                    TextField(
                      controller: inputUserName,
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: 'type usesrname',
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          prefixText: ' ',
                          suffixStyle: const TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20.0,),
                    TextField(
                      controller: inputPassword,
                      decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: 'type password',
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          prefixText: ' ',
                          suffixIcon: InkWell(
                            onTap: (){

                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                          ),
                          suffixStyle: const TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 35.0,),
                    //Login
                    _btnLogin(getScreen),
                  ],
                ),
              )
          ),
        ),
        if(isLoading)Container(
          height: getScreen.getHeight(),
          width: getScreen.getWidth(),
          child: Center(
            child: Container(
              height: 33.0,
              width: 33.0,
              child: CircularProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }//END Build

  Widget _backgroundLogin(ScreenSize getScreen){
    if(getScreen.getOrientation()==Orientation.landscape){
      print("$TAG SHOW TAB ==============");
      print("$TAG Width: ${getScreen.getWidth()}");
      return Container(
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.fitWidth,),
      );
    }
    else{
      print("$TAG SHOW Potrait ==============");
      print("$TAG Width: ${getScreen.getWidth()}");
      return Container(
        height: getScreen.getHeight(),
        width: getScreen.getWidth(),
        child: Image.asset("assets/images/Main_Page_BG.jpg", fit: BoxFit.cover,),
      );
    }
  }

  Widget _btnLogin(ScreenSize getScreen){
    return Container(
      width: getScreen.getWidth(),
      height: 50.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(color: Colors.white)),
        color: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.all(8.0),
        onPressed: () {
          if(inputUserName.text == "" || inputPassword.text == ""){
            Toast.show("Please fill correctly", context);
            return;
          }
          _onClickLogin();
        },
        child: Text(
          "Login",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  _onClickLogin(){
    setState(() {
      isLoading = true;
    });
    _postApi.login(inputUserName.text.toString(), inputPassword.text.toString()).then((response) async {
      if(response.toString().contains("Unhandled Exception")){
        _alertInfo.showAlertInfo(context,"Erro login", response);
        print("$TAG error: $response");
        setState(() {
          isLoading = false;
        });
        return;
      }
      else{
        var data = json.decode(response);
        UserModule.createUser(data);
        
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // pref.setString(Const.KEY_PREF_TOKEN, data['login']);
        print("user data---------:${data.toString()}");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AssistentView()),
              (Route<dynamic> route) => false,
        );
      }
    });

  }

}
