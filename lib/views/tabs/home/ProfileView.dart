import 'package:flutter/material.dart';
import 'package:greca/helpers/ScreenSize.dart';
import 'package:greca/views/LoginView.dart';

class ProfileView extends StatefulWidget {

  bool order;

  ProfileView({
    Key key,
    this.order
  }) : super(key: key);
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String TAG = "ProfileView ===>";

  @override
  void initState() {
    super.initState();
    print("$TAG initState running...");
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize getScreen = ScreenSize(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            //back home
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.only(top: 33.0, right: 10.0),
                child: Container(
                  width: 120.0,
                  height: 40.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.white)),
                    color: getScreen.getOrientation()==Orientation.landscape ?  Colors.black.withOpacity(0.4):Colors.black.withOpacity(0.4),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          LoginView()), (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
