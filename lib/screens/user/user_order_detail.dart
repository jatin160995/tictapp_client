import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/chat/order_chat.dart';
import 'package:tictapp/screens/user/user_order_cell.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;

class UserOrderDetail extends StatefulWidget {
  dynamic orderId;
  UserOrderDetail(this.orderId);
  @override
  _UserOrderDetailState createState() => _UserOrderDetailState();
}

class _UserOrderDetailState extends State<UserOrderDetail> {
  ExpandableController itemsController = new ExpandableController();
  ExpandableController trackController = new ExpandableController();
  ExpandableController detailController = new ExpandableController();

  List<Color> _colors = [white, transparent];
  List<double> _stops = [0.0, 0.7];
  @override
  void initState() {
    getOrdersDetailFromServer();
    crateStream();
    itemsController.expanded = true;
    trackController.expanded = true;
    detailController.expanded = true;
    //getLocationLatLng();
    super.initState();
  }

  GoogleMapController _controller;
  GoogleMapController _controller1;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.add
  }

  void _onMapCreated1(GoogleMapController controller) {
    _controller1 = controller;
    // _controller.add
  }

  double lat = 0;
  double lng = 0;

  Set<Marker> markers = new Set();
  Set<Marker> markers1 = new Set();

  getLocationLatLng() async {
    try {
      final query = isLoading
          ? ""
          : orderDetail['shipping_address_1'] +
              ", " +
              orderDetail['shipping_address_2'] +
              ", " +
              orderDetail['payment_city'] +
              ", " +
              orderDetail['payment_country'] +
              ", " +
              orderDetail['shipping_postcode'];
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      BitmapDescriptor bitmapDescriptor1 =
          await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 2),
              'assets/images/green_marker.png');
      //final Uint8List markerIcon = await Icon(Icons.markunread);
      setState(() {
        lat = first.coordinates.latitude;
        lng = first.coordinates.longitude;

        //showToast("hello");
        if (orderDetail['shipping_latitude'].toString() == "" ||
            orderDetail['shipping_latitude'].toString() == "null") {
          markers1.add(Marker(
              markerId: MarkerId("Van1"),
              position: LatLng(lat, lng),
              //rotation: heading,
              infoWindow: InfoWindow(
                title: "Driver Location",
              ),
              draggable: true,
              icon: bitmapDescriptor1));

          _controller1.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, lng), zoom: 16),
            ),
          );
        } else {
          // showToast("here");
          double shippingLat =
              double.parse(orderDetail['shipping_latitude'].toString());
          double shippingLng =
              double.parse(orderDetail['shipping_longitude'].toString());
          markers1.add(Marker(
              markerId: MarkerId("Van1"),
              position: LatLng(shippingLat, shippingLng),
              //rotation: heading,
              infoWindow: InfoWindow(
                title: "Driver Location",
              ),
              draggable: true,
              icon: bitmapDescriptor1));

          _controller1.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(shippingLat, shippingLng), zoom: 16),
            ),
          );
        }

        /* _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 16),
          ),
        );*/

        //_controller.animateCamera()
      });
    } catch (e) {
      print(e);
    }
  }

  double vanLat = 0;
  double vanLng = 0;
  final databaseReference = Firestore.instance;
  Timer dataTimer;
  crateStream() async {
    markers.clear();
    dataTimer = new Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        databaseReference
            .collection("location")
            .document(orderDetail['order_id'])
            .collection("location")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            //print(f.data['location']['lat']);
            //print(f.data['location']['lat']);
            setState(() {
              markers.add(Marker(
                markerId: MarkerId("Van1"),
                position: LatLng(
                    f.data['location']['lat'], f.data['location']['lng']),
                //rotation: heading,
                infoWindow: InfoWindow(
                  title: "Driver Location",
                ),
                draggable: true,
                //icon: bitmapDescriptor1
              ));
            });
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        f.data['location']['lat'], f.data['location']['lng']),
                    zoom: 15.0)));
          });
        });
      });
    });
  }

  bool isMapShow = false;
  @override
  Widget build(BuildContext context) {
    // print(currentstatus.toString()+"test");
    return WillPopScope(
      onWillPop: () async {
        // isMapShow ? :
        if (isMapShow) {
          isMapShow = !isMapShow;
          return false;
        } else {
          Navigator.of(context).pop(true);
          return true;
        }
      },
      child: Scaffold(
        //backgroundColor: white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  // Share.share(
                  //   "Glad to place this order from this app. Got an amazing offer.");
                  isLoading
                      ? print("")
                      :
                     (orderDetail["store_type"] == "own"  || orderDetail["store_type"] == "pickup" ) 
                     && orderDetail["order_status_id"] == "1" ?
                       Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) =>
                                  Chat(orderDetail['order_id'], "seller_chat"))) :
                                   Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) =>
                                  Chat(orderDetail['order_id'], "chats"))); 
                },
                icon: Icon(Icons.chat)),
          ],
          elevation: 1,
          iconTheme: IconThemeData(color: darkText),
          backgroundColor: white,
          centerTitle: true,
          title: Text("Order Summary", style: TextStyle(color: darkText)),
        ),
        body: isLoading
            ? Center(
                child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(placeholderImage)),
              )
            : isMapShow
                ? GoogleMap(
                    // padding: EdgeInsets.only(
                    //   bottom: 0, left: 15),
                    markers: markers,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, lng), zoom: 16),
                    zoomControlsEnabled: false,

                    onCameraMove: ((pinPosition) {}),
                    //myLocationEnabled: true,
                  )
                : ListView(
                    children: <Widget>[
                      Container(
                        color: white,
                        padding: EdgeInsets.all(15),
                        // margin: EdgeInsets.only(left:15, right: 15, top: 15),
                        child: ExpandablePanel(
                          controller: detailController,
                          header: Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(
                              "Order Details", //"Order Id: #"+orderDetail['order_id'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: darkText,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          expanded: Container(
                              color: white,
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Order Number",
                                              style: TextStyle(
                                                  color: lightestText,
                                                  fontSize: 12)),
                                          Text("#" + orderDetail['order_id'],
                                              style: TextStyle(
                                                  color: lightText,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: primaryColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        child: Text(
                                          "Reorder",
                                          style: TextStyle(color: primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Payment Method",
                                      style: TextStyle(
                                          color: lightestText, fontSize: 12)),
                                  Text(orderDetail['payment_method'],
                                      style: TextStyle(
                                          color: lightText, fontSize: 15)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Grand Total",
                                      style: TextStyle(
                                          color: lightestText, fontSize: 12)),
                                  Text(
                                      inr +
                                          double.parse(orderDetail['total'])
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: lightText,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Delivery At",
                                      style: TextStyle(
                                          color: lightestText, fontSize: 12)),
                                  Text(
                                      orderDetail['delivery_date'] +
                                          " at " +
                                          orderDetail['time_slot'],
                                      style: TextStyle(
                                          color: lightText, fontSize: 15)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text("Delivery Instructions",
                                      style: TextStyle(
                                          color: lightestText, fontSize: 12)),
                                  Text(
                                      orderDetail['comment'] != ""
                                          ? orderDetail['comment']
                                          : "N/A",
                                      style: TextStyle(
                                          color: lightText, fontSize: 15)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 100,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Shipping Address",
                                                  style: TextStyle(
                                                      color: lightestText,
                                                      fontSize: 12)),
                                              Text(
                                                  orderDetail[
                                                          'shipping_firstname'] +
                                                      " " +
                                                      orderDetail[
                                                          'shipping_lastname'] +
                                                      ",\n" +
                                                      orderDetail[
                                                          'shipping_address_1'],
                                                  style: TextStyle(
                                                      color: lightText,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(orderDetail['shipping_city'],
                                                  style: TextStyle(
                                                      color: lightText,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            //color: Colors.amber,
                                            child: Stack(
                                              children: <Widget>[
                                                Align(
                                                  child: GoogleMap(
                                                    padding: EdgeInsets.only(
                                                        bottom: 0, left: 15),
                                                    markers: markers1,
                                                    onMapCreated:
                                                        _onMapCreated1,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                            target: LatLng(
                                                                lat, lng),
                                                            zoom: 15.5),
                                                    zoomControlsEnabled: false,

                                                    onCameraMove:
                                                        ((pinPosition) {}),
                                                    //myLocationEnabled: true,
                                                  ),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                        width: 30,
                                                        height: 100,
                                                        child: Text("",
                                                            style: TextStyle(
                                                                color:
                                                                    lightText,
                                                                fontSize: 15)),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                                colors: [
                                                              white,
                                                              transparent
                                                            ])))),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          tapHeaderToExpand: true,
                          hasIcon: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        color: white,
                        padding: EdgeInsets.all(15),
                        // margin: EdgeInsets.only(left:15, right: 15, top: 15),
                        child: ExpandablePanel(
                          controller: trackController,
                          header: Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(
                              "Track Order",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: darkText,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          expanded: Container(
                              color: white,
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 5),
                              child: Container(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: createProgress()),
                                  ),
                                  Expanded(
                                    flex: 12,
                                    child: Column(
                                      children: createTrackCell(),
                                    ),
                                  ),
                                ],
                              ))),
                          tapHeaderToExpand: true,
                          hasIcon: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        color: white,
                        padding: EdgeInsets.all(15),
                        // margin: EdgeInsets.only(left:15, right: 15, top: 15),
                        child: ExpandablePanel(
                          controller: itemsController,
                          header: Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Your Order", //"Order Id: #"+orderDetail['order_id'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: darkText,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    orderDetail[
                                        'order_status'], //"Order Id: #"+orderDetail['order_id'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: orderDetail['order_status'] ==
                                                "Pending"
                                            ? orange
                                            : orderDetail['order_status'] ==
                                                    "Complete"
                                                ? greenButton
                                                : orderDetail['order_status'] ==
                                                        "Cancel"
                                                    ? Colors.red
                                                    : Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          expanded: Container(
                              color: white,
                              margin:
                                  EdgeInsets.only(left: 0, right: 0, top: 5),
                              child: Column(
                                children: createItems(),
                              )),
                          tapHeaderToExpand: true,
                          hasIcon: true,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
      ),
    );
  }

  List<Widget> createItems() {
    List<Widget> itemList = new List();
    dynamic itemFromServer = orderDetail['items'];
    for (int i = 0; i < itemFromServer.length; i++) {
      itemList.add(OrderDetailCell(
          productData: itemFromServer[i],
          addQuant: () {},
          delQuant: () {},
          delItem: () {}));
    }

    return itemList;
  }

  dynamic progressTextArray = [
    'Order Placed',
    'Processing',
    'Shipping',
    'Completed'
  ];
//dynamic progressColorArray = [Colors.amber, orange, blueColor, greenButton];
  dynamic progressColorArray = [lightGreen, lightGreen, lightGreen, lightGreen];
  int currentstatus = 0;
  List<Widget> createProgress() {
    List<Widget> progressList = new List();
    for (int i = 0; i < progressTextArray.length; i++) {
      progressList.add(
        Column(
          children: <Widget>[
            Container(
              height: i == currentstatus && currentstatus == 2 ? 71 : 32.5,
              width: 2,
              color: i == 0
                  ? transparent
                  : i > currentstatus ? iconColor : progressColorArray[i - 1],
            ),
            Container(
              height: 15,
              width: 15,
              //margin: EdgeInsets.only(top: 40, left: 15),
              decoration: new BoxDecoration(
                  color: i > currentstatus ? iconColor : progressColorArray[i],
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(7.5),
                    topRight: const Radius.circular(7.5),
                    bottomRight: const Radius.circular(7.5),
                    bottomLeft: const Radius.circular(7.5),
                  )),
              //child: Text("."),
            ),
            Container(
              height: i == currentstatus && currentstatus == 2 ? 71 : 32.5,
              width: 2,
              color: i == 3
                  ? transparent
                  : i > currentstatus ? iconColor : progressColorArray[i],
            ),
          ],
        ),
      );
    }

    return progressList;
  }

  List<Widget> createTrackCell() {
    List<Widget> trackCellList = new List();
    for (int i = 0; i < progressTextArray.length; i++) {
      trackCellList.add(Container(
        height: i == currentstatus && currentstatus == 2 ? 160 : 80,
        child: Row(
          children: <Widget>[
            /* Container(
              //margin: EdgeInsets.only(top: 40, left: 15),
              decoration: new BoxDecoration(
                  color: i <= currentstatus ? progressColorArray[i] : lightGrey,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                  )),
              child: IconButton(
                icon: Icon(Icons.done_all, color: white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),*/
            //SizedBox(width: 15),
            i == currentstatus && currentstatus == 2
                ? Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: progressColorArray[i],
                      height: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            progressTextArray[i],
                            style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            driverDetail[0]['firstname'] +
                                " " +
                                driverDetail[0]['lastname'] +
                                " is your driver. ",
                            style: TextStyle(
                                color: lightestGreen,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          orderDetail['order_status_id'].toString() == "18" ||
                                  orderDetail['order_status_id'].toString() ==
                                      "20" ||
                                  orderDetail['order_status_id'].toString() ==
                                      "17"
                              ? Text(
                                  orderDetail['order_status_id'].toString() ==
                                          "18"
                                      ? driverDetail[0]['firstname'] +
                                          "is in the store. Shopping has been started."
                                      : orderDetail['order_status_id']
                                                  .toString() ==
                                              "20"
                                          ? "Shopping Finished. " +
                                              driverDetail[0]['firstname'] +
                                              "will be delivering it soon."
                                          : driverDetail[0]['firstname'] +
                                              "is on the way to store. ",
                                  style: TextStyle(
                                      color: lightestGreen,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15),
                                )
                              : Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 89,
                                      child: GoogleMap(
                                        // padding: EdgeInsets.only(
                                        //   bottom: 0, left: 15),
                                        markers: markers,
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                            target: LatLng(lat, lng), zoom: 16),
                                        zoomControlsEnabled: false,

                                        onCameraMove: ((pinPosition) {}),
                                        //myLocationEnabled: true,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          print("view map");
                                          setState(() {
                                            isMapShow = !isMapShow;
                                          });
                                        },
                                        child: Card(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              "View Map",
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    progressTextArray[i],
                    style: TextStyle(
                        color: i <= currentstatus
                            ? progressColorArray[i]
                            : lightGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
          ],
        ),
      ));
    }

    return trackCellList;
  }

  dynamic orderDetail;
  dynamic driverDetail;
  bool isLoading = false;
  getOrdersDetailFromServer() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });

      print(getUserOrderDetail +
          "&api_token=" +
          preferences.getString(api_token));
      print({"order_id": widget.orderId});
      final response = await http.post(
          getUserOrderDetail + "&api_token=" + preferences.getString(api_token),
          body: {"order_id": widget.orderId});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        orderDetail = responseJson['order'];
        driverDetail = responseJson['driver'];

        print(responseJson);
        setState(() {
          if (orderDetail['order_status_id'].toString() == "19" ||
              orderDetail['order_status_id'].toString() == "18" ||
              orderDetail['order_status_id'].toString() == "17" ||
              orderDetail['order_status_id'].toString() == "20") {
            currentstatus = 2;
          } else if (orderDetail['order_status_id'].toString() == "5") {
            currentstatus = 3;
          }
          isLoading = false;
          getLocationLatLng();
        });
        // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => ThankyouScreen()));
        //print(responseJson);
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        Navigator.pop(context);
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    dataTimer.cancel();
    super.dispose();
  }
}
