import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/my_location.dart';
import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/screens/user/signin.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/widget/pending_order_slider.dart';
import 'package:tictapp/widget/store_grid_cell.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';

class StoreGrid extends StatefulWidget {
  @override
  _StoreGridState createState() => _StoreGridState();
}

class _StoreGridState extends State<StoreGrid> {
  String currentLocationString = "";
  saveLAtLng(double lat, double lng) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, lng);
    //showToast("here");
    // print(placemark[0].subAdministrativeArea);
    // print(placemark[0].subLocality);

    String name = placemark[0].name;
    String thoroughfare = placemark[0].thoroughfare;
    String subLocality = placemark[0].subLocality;
    String locality = placemark[0].locality;
    String subAdministrativeArea = placemark[0].subAdministrativeArea;
    String administrativeArea = placemark[0].administrativeArea;
    currentLocationString = "";
    if (thoroughfare != "") {
      currentLocationString = thoroughfare;
    }
    if (subLocality != "") {
      if (currentLocationString == "")
        currentLocationString = subLocality;
      else
        currentLocationString = currentLocationString + ", " + subLocality;
    }
    if (locality != "") {
      if (currentLocationString == "")
        currentLocationString = locality;
      else
        currentLocationString = currentLocationString + ", " + locality;
    }
    if (subAdministrativeArea != "") {
      if (currentLocationString == "")
        currentLocationString = subAdministrativeArea;
      else
        currentLocationString =
            currentLocationString + ", " + subAdministrativeArea;
    }
    if (administrativeArea != "") {
      if (currentLocationString == "")
        currentLocationString = administrativeArea;
      else
        currentLocationString =
            currentLocationString + ", " + administrativeArea;
    }
    setState(() {
      currentLocationString = currentLocationString + " ▼";
      // showToast(placemark[0].thoroughfare.toString());
    });
  }

  @override
  void initState() {
    //cartTemporary = new List();
    saveLAtLng(selectedLat, selectedLng);
    getStores();
    
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: BottomTabs(1, false),
      //bottomNavigationBar: ,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLocation(),
                  ));
            },
            icon: Icon(Icons.edit, color: lightestText,
            ),
          ),
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
        backgroundColor: white,
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyLocation(),
                ));
          },
          child: Text(
            currentLocationString,
            style: TextStyle(color: darkText, fontSize: 16),
          ),
        ),
        leading: Icon(
          Icons.location_on,
          color: primaryColor,
        ),
      ),
      body: isLoading
          ? Center(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          height: 100,
                          width: 100,
                          child: Image.asset(placeholderImage)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Searching stores near to you")
                    ],
                  ),
                ],
              ),
            )
          : ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                            height: 200,
                            child: Image.asset(
                              "assets/images/slider.png",
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Container(
                              height: 80,
                              width: 80,
                              //color: white,
                              padding: EdgeInsets.all(5),
                              child: Image.asset("assets/images/logo.png")),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: white,
                  //margin: EdgeInsets.only(top: 150),
                  child: Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: createCategory(categoriesList),
                    ),
                  ),
                ),
                 orderListFromServer.length > 0 ?Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         Container(
                          color: white,
                          margin: EdgeInsets.only(top: 20, left: 15,bottom: 10),
                          child: Text(
                            "Order In Progress",
                            style: TextStyle(
                                color: lightestText,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: IconButton(icon: Icon(Icons.refresh), onPressed: ()
                  {getData();}),
                )
                       ],
                     ),
                 PendingOrderSlider(orderListFromServer),
                   ],
                 ) : Container(),

               
                Container(
                  color: white,
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Text(
                    "Store",
                    style: TextStyle(
                        color: lightestText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Container(
                  color: white,
                  child: createStores(storeList).length != 0
                      ?
                      /* AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          createStores(storeList).length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: ScaleAnimation(
          child: FadeInAnimation(
            child:filteredCatName != "" ? filteredCatName == storeList[index]['category'].toString() ?
            StoreGridCell(storeList[index])
            : Container() :StoreGridCell(storeList[index])
            
          ),
              ),
            );
          },
        ),
      ),
    )*/

                      Column(
                          children: createStores(storeList),
                        )
                      : Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Text(
                              "No stores available in this category.",
                              style: TextStyle(
                                  color: lightestText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal),
                            )),
                      ),
                )
              ],
            ),
    );
  }

  List<Widget> createStores(List storeList) {
    List<Widget> storeWidget = new List();
    List<Widget> storeFromServerList = new List();
    List stores = storeList;
    int storeIndex = 1;
    if(stores != null)
    {
for (var store in stores) {
      if (filteredCatName != "") {
        if (filteredCatName == store['category'].toString()) {
          storeFromServerList.add(StoreGridCell(store));
        } else {
          //continue;
        }
      } else {
        storeFromServerList.add(StoreGridCell(store));
      }
      if (storeIndex % 2 == 0 || (storeIndex == stores.length)) {
        //if(storeWidget.l)
        if (storeFromServerList.length != 0) {
          storeWidget.add(Row(children: storeFromServerList));
          storeFromServerList = new List();
        }
      }

      storeIndex++;
    }
    }
    

    return storeWidget;
  }

  String filteredCatName = "";
  List<Widget> createCategory(List categoriesList) {
    List<Widget> categoryFromServerList = new List();
    List categories = categoriesList;

   /* categoryFromServerList.add(
      GestureDetector(
        onTap: () {
          setState(() {
            filteredCatName = "";
          });
        },
        child: Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            height: 90,
            width: 90,
            child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  color: filteredCatName == "" ? primaryColor : HexColor.fromHex("#cccccc"),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.fitWidth,
                          height: 30,
                          width: 30,
                          placeholder: "assets/images/all_image.png",
                          image: "cat['image']",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0, right: 3),
                        child: Text(
                          "All",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );*/
    int i =0;
    for (var cat in categories) {
      categoryFromServerList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              if(cat['name'] == "All")
              {
                  filteredCatName = "";
              }
              else
              {
                filteredCatName = cat['name'];
              }
              
            });
          },
          child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              height: 90,
              width: 90,
              child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    color:
                        i==0 && filteredCatName == "" ?primaryColor : filteredCatName == cat['name'] ? primaryColor : HexColor.fromHex(cat['color']),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.fitWidth,
                            height: 35,
                            width: 35,
                            placeholder: "assets/images/logo1.png",
                            image: cat['image'].toString() != "null"
                                ? cat['image']
                                : "cat['image']",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0, right: 3),
                          child: Text(
                            cat['name'].replaceAll('&amp;', "&"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ))),
        ),
      );
      i++;
    }

    return categoryFromServerList;
  }


getData() async {
    //print("hello");
    ApiProvider _provider = ApiProvider();
    final response = await _provider
        .post("login", {"key": apiKey, "username": website_username});
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(api_token, response["api_token"]);
    print(response.toString());
    getOrdersFromServer();
  }
  bool isLoading = true;
  dynamic storeList;
  dynamic categoriesList;
  Future<void> getStores() async {
   // print(getStoreByLocation);
    print({
        "lat": selectedLat.toString(),
        "long": selectedLng.toString()
      });
    try {
      final response = await http.post(getStoreByLocation, body: {
        "lat": selectedLat.toString(),
        "long": selectedLng.toString()
      });
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        storeList = responseJson["stores"] as List;
        categoriesList = responseJson["categories"] as List;

        print(responseJson);
       getData();
       
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {});
    }
  }


  List orderListFromServer = new List();
  getOrdersFromServer() async 
  {
    var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      orderListFromServer = new List();
    
      print(getUserOrder+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          getUserOrder+"&api_token="+preferences.getString(api_token),
          body: {"customer_id": (preferences.getInt(id).toString())}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
         if(responseJson['status'])
        {
           List allOrderList = new List(); 
           allOrderList = responseJson["data"];
           for (var order in allOrderList)
           {
             print(order);
             if(order['order_status_actual_id'] == "1" || order['order_status_actual_id'] == "2" || order['order_status_actual_id'] == "17" || order['order_status_actual_id'] == "18" || 
             order['order_status_actual_id'] == "19" || order['order_status_actual_id'] == "20")
             {
                orderListFromServer.add(order);
             }
             
           }
        //orderListFromServer = responseJson['data'] as List;
        print(responseJson);
        setState(() {
            isLoading = false;
           
          });
        }
        else
        {
          //showToast("Something went wrong");
          setState(() {
            isLoading = false;
           
          });
          
        }
        
       
          // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => ThankyouScreen()));
        //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        //showToast("Something went wrong");
        Navigator.pop(context);
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    }
    catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
  }
  }


}
