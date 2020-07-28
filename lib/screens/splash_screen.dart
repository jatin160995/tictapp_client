
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/my_location.dart';
import 'package:tictapp/utils/common.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {


askPermission () async {
     Map<Permission, PermissionStatus> statuses = await [
      Permission.location
     ].request();

  setState(() {
    
  });
  }

  void splashTimer() async
  {
    print('start');
    Future.delayed(Duration(seconds: 2) ,() {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyLocation(),
        ));
        //Navigator.pushReplacementNamed(context, "/store");
       // Navigator.pushReplacementNamed(context, "/home");
        print('end');
    });
  }

  clearPref() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.clear();
    
  }

  @override
  void initState() {
    super.initState();
    //clearPref();
    askPermission ();
    splashTimer();
  }
  @override
  Widget build(BuildContext context) {
    print('hello');
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Image(
            image: AssetImage('assets/images/loading.png'),
          ),
        ),
      ),
    );
  }


}