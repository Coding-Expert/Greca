import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool _obscureText = true;
  bool remember_flag = false;

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String user_name = pref.getString("user_name");
    String password = pref.getString("password");
    if(user_name != null && password != null){
      inputUserName.text = user_name;
      inputPassword.text = password;
    }
  }


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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          hintText: 'type username',
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
                      obscureText: _obscureText,
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
                              _toggle();
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
                    SizedBox(height: 50.0,),
                    Container(
                      width: 200,
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: CheckboxListTile(
                          title: Text("Remember Me", style: TextStyle(color: Colors.white)),
                          value: remember_flag, 
                          onChanged: (value){
                            setState(() {
                              remember_flag = value;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          // contentPadding: EdgeInsets.all(0),
                        )
                      )
                    ),
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
        if(data["loginError"] == "Username or password is wrong!"){
          Toast.show("Username or password is wrong!", context);
          setState(() {
            isLoading = false;
          });
          return;
        }
        else {
          if(remember_flag) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString("user_name", inputUserName.text.toString());
            pref.setString("password", inputPassword.text.toString());
          }
          UserModule.createUser(data);
          
          // SharedPreferences pref = await SharedPreferences.getInstance();
          // pref.setString(Const.KEY_PREF_TOKEN, data['login']);
          print("user data---------:${data.toString()}");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
                (Route<dynamic> route) => false,
          );
        }
      }
    });

  }

}
