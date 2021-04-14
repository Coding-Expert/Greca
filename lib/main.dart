import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greca/helpers/MyProvider.dart';
import 'package:greca/views/LoginView.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => MyProvider())
      ],
        child: MyApp(),)
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
        primarySwatch: Colors.blue,
        backgroundColor:Color.fromARGB(255, 16, 39, 51),
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "GoogleSans",
        appBarTheme: AppBarTheme(
            color: Colors.white
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginView(),
    );
  }
}
