  
import 'package:flutter/material.dart';

import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';



import 'pages/RegisterPage.dart';
import 'pages/LoginPage.dart';
import 'pages/Homepage.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        accentColor: Color.fromRGBO(136, 100, 172, 100),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 22.0, color: Color.fromRGBO(136, 100, 172, 100)),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(136, 100, 172, 100),
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.blueAccent,
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}