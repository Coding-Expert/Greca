import 'package:flutter/material.dart';

class AlertInfo{

  showAlertInfo(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text("$msg"),
          actions: <Widget>[
            // FlatButton(
            //   child: Text("YES"),
            //   onPressed: () {
            //     //Put your code here which you want to execute on Yes button click.
            //     Navigator.of(context).pop();
            //   },
            // ),
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}