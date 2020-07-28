import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/utils/common.dart' ;
import 'package:tictapp/widget/store_list_cell.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List stores= new List();
  bool isError = false;

  askPermission () async {
     Map<Permission, PermissionStatus> statuses = await [
      Permission.location
     ].request();

  setState(() {
    
  });
  }

  Future<void> getStores() async {
    var preferences = await SharedPreferences.getInstance();
    print('fetchdata');
    try{

      final response = await http.post(
         getStoresUrl+"&api_token=" + preferences.getString(api_token),
          body: {"lat": lat.toString(), "long": lng.toString()}
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        stores = responseJson["seller_lists"] as List;

        setState(() {
          isError = false;
          print('setstate');
        });
      }
      else
      {
        setState(() {
          isError = true;
        });
      }

    }
    catch(e){
      setState(() {

      });
    }
  }


      getToken() async
    {
      //print("hello");
      ApiProvider _provider = ApiProvider();
      final response = await _provider.post("login", {"key" : apiKey , "username": website_username});
      var preferences = await SharedPreferences.getInstance();
      preferences.setString(api_token, response["api_token"]);
      print (response.toString());
      getStores();

    }

String currentLocationString = "";
double lat;
double lng;
void currentLocation() async 
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    print (placemark[0].subAdministrativeArea);
    print(placemark[0].subLocality);
    getToken();
    setState(() {
      currentLocationString =  placemark[0].subLocality +", "+ placemark[0].subAdministrativeArea;
    });
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLocation();
    askPermission ();
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      /*appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        elevation: 0,
        title: Text('Choose Store',
          style: TextStyle(
              fontWeight: FontWeight.bold,
            color: darkText
          ),
        ),
      ),*/
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Text('Stores',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: lightText,
                  fontSize: 28,

                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                SizedBox(width: 13,),
                Icon(Icons.location_on, color: primaryColor, size: 18),
                Container(
                            margin: EdgeInsets.only(left: 10, right: 20),
                            child: Text(currentLocationString,
                                style: TextStyle(
                                  color: lightestText,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                )),
                          ),
              ],
            ),
                ],
              ),
            ),
           
            Align(
              alignment: Alignment.topCenter,
               child:  Container(
                 margin: EdgeInsets.only(top: 100),
                 child: ListView(
                   children: <Widget>[
                     createStores(stores)
                   ],
                 ) /*GridView.count(
      //primary: false,
      padding: const EdgeInsets.all(15),
      //childAspectRatio: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: createGrid(stores),
    ),*/
               ),
            ),
          ],
        )
      ),
    );
  }


  Widget createStores (List stores)
  {

    List<Widget> storeWidgetList = new List();
    for (int storeIndex = 0; storeIndex< stores.length; storeIndex++)
    {
      
        storeWidgetList.add(new StoreListCell(stores[storeIndex]));
      

    }

    if(stores.length == 0)
    {
      if(!isError)
      return  Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator()));
      else
        return Center(child: Text('No Store Avaiable'));
    }
    else
      {
        return new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: storeWidgetList);
      }

  }

  List<Widget> createGrid (List stores)
  {

    List<Widget> storeWidgetList = new List();
    for (int storeIndex = 0; storeIndex < stores.length; storeIndex++)
    {
      
        storeWidgetList.add(new StoreListCell(stores[storeIndex]));
      

    }

    if(stores.length == 0)
    {
      if(!isError)
      {
        storeWidgetList.add(Container(height: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator())));
        return storeWidgetList;
      }
       
      else
      {
        storeWidgetList.add(Center(child: Text('No Store Avaiable')));
         return storeWidgetList;
      }
       
    }
    else
      {
         storeWidgetList.add(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: storeWidgetList));
        return  storeWidgetList;
      }

  }
}
