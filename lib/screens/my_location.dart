import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tictapp/screens/store_detail.dart';
import 'package:tictapp/screens/store_grid.dart';
import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/screens/user/signin.dart';
import 'package:tictapp/utils/common.dart';

class MyLocation extends StatefulWidget {
  MyLocation();
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation>
    with AutomaticKeepAliveClientMixin<MyLocation> {
  @override
  bool get wantKeepAlive => true;
  String _mapStyle;

  GoogleMapController _controller;
  Set<Marker> markers = new Set();

  double lat = 0.0;
  double lng = 0.0;

  double heading = 0.0;
  BitmapDescriptor bitmapDescriptor;
  Position currentPosition;
  Geolocator geolocator = new Geolocator();

  int cameraLoadCount = 0;
  StreamSubscription geolocatorStream;

  bool isLoading = true;
  getCurrentPosition() {
    if(!isLoading)
    {
      if(mounted)
setState(() {
      isLoading = true;
    });
    }
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          if(mounted)
      setState(() {
        saveLAtLng(position.latitude, position.latitude);
        lat = position.latitude;
        lng = position.longitude;
        heading = position.heading;
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 16),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
    if(mounted)
    setState(() {
      isLoading = false;
    });
  }

  String currentLocationString = "";
  String vanIDSaved = "";
  saveLAtLng(double lat, double lng) async {
    if(!isLoading)
    {
      if(mounted)
setState(() {
      isLoading = true;
    });
    }
    
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, lng);

    selectedLat = lat;
    selectedLng = lng;

    String name = placemark[0].name;
    String thoroughfare = placemark[0].thoroughfare;
    String subLocality = placemark[0].subLocality;
    String locality = placemark[0].locality;
    String subAdministrativeArea = placemark[0].subAdministrativeArea;
    String administrativeArea = placemark[0].administrativeArea;
    currentLocationString = "";
    if(thoroughfare != "")
    {
      currentLocationString = thoroughfare;
    }
    if(subLocality != "" )
    {
      if(currentLocationString == "")
      currentLocationString =  subLocality;
      else
      currentLocationString =currentLocationString +", "+  subLocality;

    }
    if(locality != "" )
    {
      if(currentLocationString == "")
      currentLocationString =  locality;
      else
      currentLocationString =currentLocationString +", "+  locality;

    }
    if(subAdministrativeArea != "" )
    {
      if(currentLocationString == "")
      currentLocationString =  subAdministrativeArea;
      else
      currentLocationString =currentLocationString +", "+  subAdministrativeArea;

    }
    if(administrativeArea != "" )
    {
      if(currentLocationString == "")
      currentLocationString =  administrativeArea;
      else
      currentLocationString =currentLocationString +", "+  administrativeArea;

    }

    // print(placemark[0].subAdministrativeArea);
    // print(placemark[0].subLocality);
    if(mounted)
    setState(() {
      isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.setMapStyle(_mapStyle);

    // _controller.add
  }

  askPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location].request();
    if(mounted)
    setState(() {});
  }

  moveCamera() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(8.983333, -79.516672), zoom: 15),
      ),
    );
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      moveCamera();
    });
  }


  @override
  void initState() {
    askPermission();

    //currentLocation();
    getCurrentPosition();
    //currentLocation();
    startTimer();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }


  isLoggedIn() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      if (preferences.getBool(is_logged_in ?? false)) {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => Profile()));
      } else {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => SignIn("profile")));
      }
    } catch (e) {
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => SignIn("profile")));
    }
  }

  bool notificationViewState = false;
  int funcCallNumber = 0;
  @override
  Widget build(BuildContext context) {
    askPermission();
    return Scaffold(
      /*drawer: DrawerMenu(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Badge(
                  badgeContent: Text(
                    cartCount.toString(),
                    style: TextStyle(color: white),
                  ),
                  child: Icon(Icons.notifications)),
              onPressed: () {
                setState(() {
                  notificationViewState = !notificationViewState;
                });
              })
        ],
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          "Dashboard",
          style: TextStyle(color: darkText),
        ),
        backgroundColor: white,
        centerTitle: true,
      ),*/
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: lightestText,
                ),
                onPressed: () {
                  isLoggedIn();
                },
              ),
        ],
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          "Select Your Location",
          style: TextStyle(color: darkText),
        ),
        backgroundColor: white,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      "Get Stores",
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                    onPressed:  () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreGrid(),
                            //builder: (context) => StoreDetail("2"),
                          ));
                    },
                    color: lightGreen,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 50),
              child: GoogleMap(
                //markers: markers,
                padding: EdgeInsets.only(
                                                  right: 10, top: 60),
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(8.983333, -79.516670), zoom: 15),
                onCameraMove: ((pinPosition) {
                  if (funcCallNumber == 8) {
                    saveLAtLng(pinPosition.target.latitude,
                        pinPosition.target.longitude);
                    funcCallNumber = 0;
                  }
                  funcCallNumber++;
                  selectedLat = pinPosition.target.latitude;
                  selectedLng = pinPosition.target.longitude;
                  // print(pinPosition.target.latitude);
                  // print(pinPosition.target.longitude);
                }),
                myLocationEnabled: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: white,
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.my_location,
                        color: greenButton,
                        size: 15,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(currentLocationString,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: lightestText, fontSize: 15)),
                      ),
                      isLoading ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()) : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 40,
                width: 40,
                child: Image.asset("assets/images/map_pin_new.png")),
          )
        ],
      )),
    );
  }

  bool isMoving = true;

  @override
  void dispose() {
    //geolocatorStream.cancel();
    super.dispose();
  }
}
