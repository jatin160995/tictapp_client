import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/my_location.dart';
import 'package:tictapp/screens/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/screens/store_grid.dart';
import 'package:tictapp/screens/updates/all_category.dart';
import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/screens/user/signin.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/horizontal_product_list.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/widget/updates/bottom_bar.dart';
import 'package:tictapp/model/ApiProvider.dart';

class StoreDetail extends StatefulWidget {
  String storeId;
  StoreDetail(this.storeId);
  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  List<Widget> catWidgetList = new List();
  String name = '';

  void currentLocation() async {
    /// Position position = await Geolocator()
    //  .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(selectedLat, selectedLng);
    print(placemark[0].subAdministrativeArea);
    print(placemark[0].subLocality);
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
    });
  }

  @override
  void initState() {
    super.initState();
    openedStoreId = widget.storeId;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    currentLocation();
    getData();
    cartId = '';
    //cartCount = 0;
    addressAdded = false;
    gettingCartId = false;
    //cartList = new List();
    //print(widget.storeData);

    //getCategories();
  }

  @override
  void didUpdateWidget(StoreDetail oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  void getCategories() {
    List categories = homeData['latestProducts'] as List;
    for (int i = 0; i < categories.length; i++) {
      catWidgetList
          .add(HorizontalProductList(1, categories[i], categories[i]['title']));
      /*try
      {
        catWidgetList.add(HorizontalProductList(categories[i], categories[i]['children_data'][0]['id'], categories[i]['name']));
      }
      catch(e)
      {
        catWidgetList.add(HorizontalProductList(1, categories[i]['id'], categories[i]['name']));
      }*/
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    print('onDispose');
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

  ApiProvider _provider = ApiProvider();
  getData() async {
    //print("hello");
    final response = await _provider
        .post("login", {"key": apiKey, "username": website_username});
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(api_token, response["api_token"]);
    print(response.toString());
    getHomeData();
  }

  int countFromLocal = 0;

  String currentLocationString = '';

  ScrollController _controller;
  bool showStoreBar = false;

  _scrollListener() {
    if (_controller.position.pixels > 150 && !showStoreBar) {
      setState(() {
        showStoreBar = true;
      });
    } else if (showStoreBar && _controller.position.pixels <= 150) {
      setState(() {
        showStoreBar = false;
      });
    }

    // print(_controller.position.pixels);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Do you want to exit?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes, exit'),
                      onPressed: () {
                        // clearCartFromServer();
                        cartId = '';
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              });

          return value == true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            leading: Icon(
              Icons.location_on,
              color: primaryColor,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: lightestText,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FindItem(widget
                              .storeId) //Search( widget.storeData['id'].toString()),
                          ));
                },
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
                style: TextStyle(
                    color: darkText,
                    fontSize: 16,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          /*floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/cart');
        },
        backgroundColor: primaryColor,
        child: Badge(
          badgeColor: white,
          badgeContent: Text(
            countFromLocal.toString(),
          style: TextStyle(
              color: primaryColor
          ),),
          child: Icon(Icons.shopping_cart, size: 25),
        ),
      ),*/
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
                          Text("Fetching store information")
                        ],
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: bottomTabHeight),
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView(
                          controller: _controller,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                      height: 150,
                                      child: homeData["store_detail"]
                                                  ['store_banner'] ==
                                              ''
                                          ? Image.asset(
                                              "assets/images/background.jpg",
                                              fit: BoxFit.cover,
                                            )
                                          : FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              placeholder: placeholderImage,
                                              image: homeData["store_detail"][
                                                  'store_banner'] //widget.productData['custom_attributes'][0]['value'],
                                              )),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    height: 150,
                                    color: transparentBlack,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      child: Container(
                                          height: 75,
                                          width: 75,

                                          //color: white,
                                          padding: EdgeInsets.all(5),
                                          child: FadeInImage.assetNetwork(
                                              //fit: BoxFit.cover,
                                              height: 80,
                                              width: 80,
                                              placeholder: placeholderImage,
                                              image: homeData["store_detail"][
                                                  'store_logo'] //widget.productData['custom_attributes'][0]['value'],
                                              )),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      //color: transparentBackground,
                                      margin: EdgeInsets.only(top: 91),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        homeData["store_detail"]["store_name"],
                                        style: TextStyle(
                                            color: background,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold
                                            //decoration: TextDecoration.underline
                                            ),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => StoreGrid(),
                                            ));
                                      },
                                      child: Container(
                                          color: transparentBackground,
                                          margin: EdgeInsets.only(top: 120),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Change Store >",
                                            style: TextStyle(
                                                color: white,
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.underline),
                                          ))),
                                )
                              ],
                            ),
                            /*GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FindItem(
                                            "") //Search( widget.storeData['id'].toString()),
                                        ));
                              },
                              child: Container(
                                height: 65,
                                child: Card(
                                    color: white,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Text(
                                                'Search product, brand, category...',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: lightestText,
                                                    fontSize: 16)),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),*/
                            createBannerSlider().length == 0
                                ? Container()
                                : Container(
                                    height: 150,
                                    child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: createBannerSlider()),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 10,),
                                  child: Text("Categories",
                                      style: TextStyle(
                                          color: darkText,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                                 Container(
                                   padding: EdgeInsets.only(top:10, right: 15, left: 15, bottom: 15),
                                   child: GestureDetector(
                onTap: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategories(),
                        ));
                },
                child: Text( 'View All >',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
              ),
                                 )
                              ],
                            ),
                            Container(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: createCategory(),
                              ),
                            ),
                            Column(children: catWidgetList),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomTabs(1, true),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Visibility(
                        visible: showStoreBar,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70,
                              color: white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: Container(
                                              height: 50,
                                              width: 50,

                                              //color: white,
                                              padding: EdgeInsets.all(5),
                                              child: FadeInImage.assetNetwork(
                                                  //fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                  placeholder: placeholderImage,
                                                  image: homeData[
                                                          "store_detail"][
                                                      'store_logo'] //widget.productData['custom_attributes'][0]['value'],
                                                  )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        homeData["store_detail"]["store_name"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: darkText,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => StoreGrid(),
                                            ));
                                      },
                                      child: Container(
                                          //color: transparentBackground,
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Change Store >",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.underline),
                                          )))
                                ],
                              ),
                            ),
                            Divider(height: 1)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }

  String getBanner2() {
    String banner2Url = "";
    try {
      banner2Url = homeData['banners']['banner2'][0]['image'];
    } catch (e) {
      banner2Url = "";
    }

    return banner2Url;
  }

  List<Widget> createCategory() {
    List<Widget> categoryFromServerList = new List();
    List categories = homeData['categories'] as List;
    for (var cat in categories) {
      categoryFromServerList.add(
        Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            height: 105,
            width: 90,
            child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.fitWidth,
                        height: 50,
                        width: 50,
                        placeholder: placeholderImage,
                        image: cat['image'],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, right: 3),
                      child: Text(
                        cat['name'].replaceAll('&amp;', "&"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: darkText,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ))),
      );
    }

    return categoryFromServerList;
  }

  List<Widget> createBannerSlider() {
    List<Widget> bannerWidgetList = new List();
    try {
      List bannerList = homeData['banners']['banner1'] as List;
      for (int i = 0; i < bannerList.length; i++) {
        bannerWidgetList.add(
          Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              height: 130,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 130,
                    width: 240,
                    placeholder: placeholderImage,
                    image: bannerList[i][
                        'image'] //widget.productData['custom_attributes'][0]['value'],
                    ),
              )),
        );
      }
    } catch (e) {}

    return bannerWidgetList;
  }

  bool isLoading = true;
  dynamic homeData;
  Future<void> getHomeData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var preferences = await SharedPreferences.getInstance();
      print(homeUrl + "&api_token=" + preferences.getString(api_token));
      final response = await http.post(
          homeUrl + "&api_token=" + preferences.getString(api_token),
          body: {"store_id": widget.storeId});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if (true) {
          homeData = responseJson;
          openedStoreName = homeData["store_detail"]["store_name"];
          print(homeData);
          print(homeData['categories']);
          setState(() {
            isLoading = false;
            getCategories();
          });
          print(responseJson);
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
        }
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }

    void exitDialog() async {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Do you want to exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes, exit'),
                  onPressed: () {
                    // clearCartFromServer();
                    cartId = '';
                    Navigator.of(context).pop(true);
                    Navigator.pop(context);
                    print('exit');
                  },
                ),
              ],
            );
          });
    }
  }
}
