import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveVan extends StatefulWidget {
  @override
  _LiveVanState createState() => _LiveVanState();
}


final databaseReference = Firestore.instance;
updateLocation() async
{
  await databaseReference.collection("locations").document("vanID").delete();
  DocumentReference ref = await databaseReference.collection("locations").document("vanID").collection("currentLocation")
        .add({
      'lat': "31.342297",
      'lng': "75.570481",
    });
    print(ref.documentID);
    
    
}

class _LiveVanState extends State<LiveVan> {

  GoogleMapController _controller ;
  Set<Marker> markers = new Set();
  
  double lat = 0.0;
  double lng = 0.0;
  BitmapDescriptor bitmapDescriptor;

  void currentLocation() async 
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/van2.png');
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      markers.add(Marker(markerId: MarkerId("1609"),
      position: LatLng(lat, lng),
      draggable: true,
      icon: bitmapDescriptor
      ));
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 16.0)));
    });
    updateLocation();
  }



  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.add
   
  }

  @override
  void initState()
  {
    askPermission();
    currentLocation();
    super.initState();
  }
  askPermission () async {
     Map<Permission, PermissionStatus> statuses = await [
      Permission.location
     ].request();

  setState(() {
    
  });
  }
  @override
  Widget build(BuildContext context) {
    print(lat.toString() + lng.toString());
    askPermission();
    //currentLocation();
    return Scaffold(
        appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text("Live van",
            style: TextStyle(
              color: darkText
            )
            ),
      ),
        bottomNavigationBar: BottomTabs(3, true),
        body: SafeArea(
                  child:Stack(
                    children: <Widget>[
                       Align(
                         alignment: Alignment.topCenter,
                         
                         child: Container(
                           margin: EdgeInsets.only(bottom: 50),
                           child: GoogleMap(
                        markers: markers,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
                        onCameraMove: ((pinPosition) 
                        {
                            print(pinPosition.target.latitude);
                            print(pinPosition.target.longitude);
                        }),
                        myLocationEnabled: true,
                        
                      ),
                         ),
                       ),
                       Align(
                         alignment: Alignment.bottomCenter,
                         child: SizedBox(
                           width: double.infinity,
                             child: Container(
                               color: white,
                             height: 50,
                             child: Row(
                               children: <Widget>[
                                 Expanded(
                                   flex: 1,
                                   child: GestureDetector(
                                     onTap: (){
                                       infoDialog();
                                     },
                                       child: Container(
                                       height: 50,
                                       color: white,
                                       margin: EdgeInsets.only(right:10),
                                       child: Center(
                                         child: Text(
                                           "Come To Me",
                                           textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: lightText,
                                              fontWeight: FontWeight.bold,
                                              
                                            ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   flex: 1,
                                   child: GestureDetector(
                                     onTap: (){
                                       mapDialog();
                                     },
                                      child: Container(
                                       margin: EdgeInsets.only(left:15),
                                       height: 50,
                                       color: white,
                                       child: Center(
                                         child: Text(
                                           "Book for someone",
                                           textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: lightText,
                                              fontWeight: FontWeight.bold,
                                            ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                                 
                               ],
                             ),
                           ),
                         ),
                         ),
                         Align(
                         alignment: Alignment.bottomCenter,
                         child: Container(
                        margin: EdgeInsets.only(top: 40, left: 0, bottom: 15),
                        padding: EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0),
                                bottomRight: const Radius.circular(40.0),
                                bottomLeft: const Radius.circular(40.0),
                              )
                        ),
                        child: Container(
                            height: 37,
                            width:37,
                            child: Image.asset("assets/images/van2.png"))
                      ),
                         ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text("20 mins to you",
                            style: TextStyle(
                              color: lightestText,
                              fontSize: 10.5
                            ),),
                          ),
                        ),

                        Align(
                         alignment: Alignment.bottomLeft,
                         child: GestureDetector(
                           onTap: (){
                            openWhatsApp();
                           },
                        child: Container(
                        margin: EdgeInsets.only(top: 40, left: 15, bottom: 90),
                        padding: EdgeInsets.all(10),
                        decoration: new BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0),
                                bottomRight: const Radius.circular(40.0),
                                bottomLeft: const Radius.circular(40.0),
                              )
                        ),
                        child: Container(
                            height: 35,
                            width:35,
                            child: Image.asset("assets/images/whatsapp.png"))
                      ),
                         ),
                       )
                    ],
                  )
        ),
      );
  }




  void mapDialog() async
  {
    final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Wrap(
                children: <Widget>[
                  Container(
                  child: Column(
                    children: <Widget>[
                       Text("Select Location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                      SizedBox(height: 10),
                     Stack(
                       children: <Widget>[
                         Align(
                           alignment: Alignment.topCenter,
                           child: Container(
                            height: 300,
                            child: GoogleMap(
                                //markers: markers,
                                //onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 15.5),
                                onCameraMove: ((pinPosition) 
                                {
                                  print(pinPosition.target.latitude);
                                  print(pinPosition.target.longitude);
                                }),
                                myLocationEnabled: true,
                            ),
                          ),
                         ),
                         Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 300,
                            child: Center(
                              child: Container(
                                height: 45,
                                width: 45,
                                child: Image.asset("assets/images/map_marker.png"))//Icon(Icons.pin_drop, size: 40,color: primaryColor,)
                            )
                          ),
                        ),
                       ],
                     )
                    ],
                  ),
                ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  color: primaryColor,
                  child: Text('Book Van',
                  style: TextStyle(
                    color: white,
                    fontSize: 16
                  ),),
                  onPressed: () {
                  // clearCartFromServer();
                    Navigator.of(context).pop(true);
                    infoDialog();
                    //Navigator.pop(context);
                    print('exit');

                  },
                ),
              ],
            );
          }
      );
  }






  void infoDialog() async
    {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Wrap(
                children: <Widget>[
                  Container(
                  child: Column(
                    children: <Widget>[
                      Text("Thank you!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                      SizedBox(height: 10),
                      Text('Your request has been sent to the van administrator. We will notify you about the confirmation. ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightestText,
                        fontSize: 13
                      ),),
                      SizedBox(height: 10),
                      Icon(Icons.done_outline, color: greenButton, size: 40,)
                      
                    ],
                  ),
                ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                  // clearCartFromServer();
                    Navigator.of(context).pop(true);
                    //Navigator.pop(context);
                    print('exit');

                  },
                ),
              ],
            );
          }
      );

    }

    openWhatsApp() async
    {
      var whatsappUrl ="whatsapp://send?phone="+mobileNumber;
      await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
    }


 
}