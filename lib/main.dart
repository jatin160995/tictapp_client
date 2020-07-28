import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictapp/screens/home.dart';
import 'package:tictapp/screens/splash_screen.dart';
import 'package:tictapp/screens/store_detail.dart';
import 'package:tictapp/utils/common.dart';

void main() {
  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
     
    
  ));
  runApp(MaterialApp(
    routes: {
    '/': (context) => SplashScreen(),
    '/home': (context) => Home(),
    '/store': (context) => StoreDetail(null),
    
  },
  theme: ThemeData(fontFamily: 'proxima',
  primaryColor: primaryColor,accentColor: primaryColor),
  ));
}
