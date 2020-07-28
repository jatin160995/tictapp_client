import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/payment_details.dart';
import 'package:tictapp/screens/user/address_book.dart';
import 'package:tictapp/widget/order_detail_cell.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:stripe_payment/stripe_payment.dart';

String cardNumber = '';
String expiryDate = '';
String cardHolderName = '';
String cvvCode = '';
bool isCvvFocused = false;

class OrderDetail extends StatefulWidget {
  //dynamic addressObject;

  //OrderDetail(this.addressObject);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool isLoading = false;
  bool isLoaded = false;

  String dropdownValue = '5';

  double subTotal = 0;
  double grandTotal = 0;
  double driverTip = 0;
  double shipping = 7.99;
  double serviceFeePercent = 10;
  double serviceFee = 0;
  double taxPercent = 6;
  double tax = 0;

  ExpandableController expandableController = new ExpandableController();
  ExpandableController dateTimeController = new ExpandableController();
  ExpandableController commentController = new ExpandableController();
  ExpandableController addressController = new ExpandableController();

  ScrollController _controller = ScrollController();

  List<String> getDropdownValues() {
    List<String> drodownValues = new List();
    drodownValues.add('5');
    drodownValues.add('10');
    drodownValues.add('15');
    drodownValues.add('20');
    drodownValues.add('0');
    return drodownValues;
  }

  double calculateDriverTip(double percentagle) {
    dynamic driverTip1 = 0;
    driverTip1 =
        double.parse(subTotal.toStringAsFixed(2)) * (percentagle / 100);
    driverTip = driverTip1;
    grandTotal = baseGrandTotal + driverTip1;
    return driverTip1;
  }

/*

  double calculateTax(double taxPer, double amount)
  {
    double calTax = 0;
    calTax = double.parse(amount.toStringAsFixed(2))*(taxPer/100);

    return calTax;
  }
*/
  String dateOfDelivery = '';
  String timeFrom = '';
  String timeTo = '';
  String comment = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _autoValidate = false;

  dynamic timeObject = '';

  int selectedTimeSlot = 0;

  TextEditingController cvvController = new TextEditingController();

  int selectedDriverFee = 0;
  dynamic selectedDriverFeeArray = [0, 10, 20, 30, 50];

  List<Widget> createProduct(List products) {
    // subTotal = 0;

    List<Widget> productList = new List();

    if (products.length > 0) {
      for (int i = 0; i < products.length; i++) {
        productList.add(OrderDetailCell(
          productData: products[i],
          addQuant: () {
            print('add quant');
          },
          delQuant: () {
            setState(() {
              print('minus');
            });
          },
          delItem: () {
            setState(() {
              print('minus');
            });
          },
        ));
      }

      productList.add(Divider(height: 1));
      /*productList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(height: 15),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 5, right: 15, top: 3),
              color: white,
              child: TextField(
                enabled: isLoading ? false : true,
                textCapitalization: TextCapitalization.characters,
                onChanged: (text) {
                  //postalCode = text;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.event_note,
                  ),
                  hintText: 'Notes',
                ),
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ));*/

      productList.add(SizedBox(height: 15));

      var driverTipDesign = new Container(
        color: white,
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1, child: Icon(Icons.local_atm, color: lightText)),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 12,
                    child: Text("Support delivery partners",
                        style: TextStyle(
                            color: lightText,
                            fontSize: 15,
                            fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
                "Thank your delivery partner for helping you stay safe indoors. Support them with a tip.",
                style: TextStyle(color: lightestText, fontSize: 12)),
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: createTips())
          ],
        ),
      );
      productList.add(driverTipDesign);
      productList.add(SizedBox(height: 14));

      var couponDesign = new Card(
        elevation: 0,
        //margin: EdgeInsets.only(left: 15, right: 15),
        child: GestureDetector(
          onTap: () {
            showCouponModal();
          },
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 2, child: Icon(Icons.redeem, color: lightText)),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 12,
                    child: Text("Apply Coupon Code",
                        style: TextStyle(
                          color: lightText,
                          fontSize: 17,
                        ))),
                Expanded(
                    flex: 1,
                    child: Text(">",
                        style: TextStyle(
                          color: darkText,
                          fontSize: 17,
                        )))
              ],
            ),
          ),
        ),
      );
      productList.add(couponDesign);

      var pricesDesign = new Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          color: white,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Text("Bill Total",
                  style: TextStyle(
                      color: darkText,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              for (var prices in totalList)
                prices['title'] != "Total"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(prices['title'],
                                  style: TextStyle(
                                      color: prices['title']
                                              .toString()
                                              .contains("Coupon")
                                          ? primaryColor
                                          : lightText,
                                      fontSize: 14.5)),
                              Text(prices['text'],
                                  style: TextStyle(
                                      color: prices['title']
                                              .toString()
                                              .contains("Coupon")
                                          ? primaryColor
                                          : lightText,
                                      fontSize: 14)),
                            ],
                          ),
                          prices['comments'] != ""
                              ? Text(
                                  prices['comments'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: lightestText,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10)
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Driver Tip",
                                  style: TextStyle(
                                      color: lightText, fontSize: 14.5)),
                              Text(
                                  "(" +
                                      availtip[selectedDriverFee]["valdata"]
                                          .toString() +
                                      ")   " +
                                      inr +
                                      calculateTotal(double.parse(
                                              availtip[selectedDriverFee]
                                                      ["valdata"]
                                                  .toString()
                                                  .replaceAll("%", "")))
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: lightText, fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  prices['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  inr +
                                      double.parse((prices['amount'] +
                                                  calculateTotal(double.parse(
                                                      availtip[selectedDriverFee]
                                                              ["valdata"]
                                                          .toString()
                                                          .replaceAll(
                                                              "%", ""))))
                                              .toString())
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ])
                        ],
                      ),
            ],
          ));

      productList.add(pricesDesign);
      // setState(() {

      //});
      //subTotal = subTotal + driverTip;
      print(driverTip);

      // var submitButton = ;
      //productList.add(submitButton);
    } else {
      if (isLoaded) {
        productList.add(new Container(
            height: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                children: <Widget>[
                  Text(
                    'Cart is empty!',
                    style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 22),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: Image.asset("assets/images/empty_cart.png"),
                  )
                ],
              ),
            )));
      } else {
        productList.add(Center(
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(50),
                      height: 100,
                      width: 100,
                      child: Image.asset(placeholderImage)),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading...")
                ],
              ),
            ],
          ),
        ));
      }
    }
    return productList;
  }

  double calculateTotal(double percentage) {
    dynamic subtotal = 0;
    for (int i = 0; i < totalList.length; i++) {
      if (totalList[i]['title'] == "Sub-Total") {
        subtotal = totalList[i]['amount'];
      }
    }
    print(percentage);
    print(subtotal * (percentage / 100));
    return subtotal * (percentage / 100);
  }

  //String tip_code = "";
  List<Widget> createTips() {
    List<Widget> tipsList = new List();
    for (int i = 0; i < availtip.length; i++) {
      tipsList.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDriverFee = i;
            });
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              color: selectedDriverFee == i ? primaryColor : white,
              height: 30,
              width: 70,
              child: Center(
                  child: Text(
                availtip[i]['valdata'],
                style:
                    TextStyle(color: selectedDriverFee == i ? white : darkText),
              )),
            ),
          ),
        ),
      );
    }

    return tipsList;
  }

  @override
  void initState() {
    getShippingMethod();

    getCurrentLocation();
    super.initState();

    //StripeOptions(publishableKey: "pk_test_KwrXXsuQmvLz6Qy5ISuCRFVn003YYcIKZ2", merchantId: "info@lanesopen.com", androidPayMode: 'test'));
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(addressToOrderDetail);
   // isLoading = false;
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Edit Order',
                style: TextStyle(color: darkText),
              ),
            )
          ],
          elevation: 1,
          iconTheme: IconThemeData(color: darkText),
          centerTitle: true,
          backgroundColor: white,
          title: Text(
            'Order Detail',
            style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 150),
                child: ListView(
                  children: createProduct(prodList),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Divider(height: 1, color: lightGrey),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 98,
                padding: EdgeInsets.all(15),
                color: white,
                margin: EdgeInsets.only(bottom: 50),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.only(right: 15),
                      color: iconColor,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          color: white,
                          child: Icon(Icons.location_on,
                              color: lightestText, size: 30)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Shipping Address",
                              style: TextStyle(
                                  color: darkText,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(
                              addressToOrderDetail['firstname'] +
                                  " " +
                                  addressToOrderDetail['lastname'] +
                                  "\n" +
                                  addressToOrderDetail['address_1'] +
                                  ", " +
                                  addressToOrderDetail['city'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: lightestText,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      AddressBook("Select Address")));
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("Change Address",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 50,
                    //margin: EdgeInsets.only(left: 15, right: 15, bottom: 50),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => PaymentDetails(
                                availtip[selectedDriverFee]["textdata"])));
                      },
                      color: greenButton,
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(white))
                          : Text(
                              'Proceed to Pay',
                              style: TextStyle(color: white, fontSize: 16),
                            ),
                    ),
                  ),
                ))
          ],
        ));
  }

  int couponType = 0; // 1=Percentage, 2=Fixed
  double couponValue = 0;

  showCouponModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          List<Widget> createCoupon() {
            List<Widget> couponWidgetList = new List();
            for (int i = 0; i < couponsList.length; i++) {
              couponWidgetList.add(Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(couponsList[i]['name'],
                            style: TextStyle(
                                color: lightText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Coupon code ",
                            style: TextStyle(
                                color: lightestText,
                                fontSize: 11,
                                fontWeight: FontWeight.normal)),
                        SizedBox(height: 3),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: blueColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Text(
                            couponsList[i]['code'],
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        getUserToken(couponsList[i]['code']);
                      },
                      child: Text("APPLY",
                          style: TextStyle(
                              color: blueColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ));
              couponWidgetList.add(Divider());
            }

            return couponWidgetList;
          }

          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setCouponState /*You can rename this!*/) {
            return Container(
                height: 300,
                color: white,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          color: blueColor,
                          height: 50,
                          child: Center(
                              child: Text(
                            "Select Coupon Code",
                            style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                    couponsList.length == 0
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: 100),
                              child: Text(
                                "Coupon not available",
                                style:
                                    TextStyle(color: iconColor, fontSize: 18),
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: 50),
                              height: 250,
                              child: ListView(
                                children: createCoupon(),
                              ),
                            ))
                  ],
                ));
          });
        });
  }

  bool applyingCoupon = false;
  Future<void> getUserToken(String couponCode) async {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    try {
      print(applyCouponUrl + "&api_token=" + preferences.getString(api_token));
      print(couponCode);
      final response = await http.post(
          applyCouponUrl + "&api_token=" + preferences.getString(api_token),
          body: {"coupon": couponCode});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        getShippingMethod();
        print(responseJson.toString());
        setState(() {
          isLoading = true;
        });

        ///getTotals();

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
        isLoading = false;
      });
    }
  }

  String currentLocation = "";

  void getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark[0].subAdministrativeArea);
    print(placemark[0].subLocality);
    setState(() {
      currentLocation =
          placemark[0].subLocality + ", " + placemark[0].subAdministrativeArea;
    });
  }

  List prodList = new List();
  List totalList = new List();
  List availtip = new List();
  List couponsList = new List();

  double baseGrandTotal = 0;

  getTotals() async {
    var preferences = await SharedPreferences.getInstance();
    ApiProvider _provider = ApiProvider();
    final response = await _provider.post(
        "cart/products&api_token=" + preferences.getString(api_token),
        {"customer_id": (preferences.getInt(id)).toString()});
    /* if(response['status'])
        {*/
        print(response);
    setState(() {
      isLoading = false;
      isLoaded = false;
      prodList = response['products'];
      totalList = response['totals'];
      availtip = response['availtip'];
      couponsList = response['coupons'];
    });
    
    /*}
        else
        {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
          
        } */

    print(response);
  }

  setShippingMethod() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });
      print(setShippingMethodUrl +
          "&api_token=" +
          preferences.getString(api_token));
      final response = await http.post(
          setShippingMethodUrl +
              "&api_token=" +
              preferences.getString(api_token),
          body: {"shipping_method": "flat.flat"});
      //response.add(utf8.encode(json.encode(itemInfo)));
 print(response.body);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if (responseJson['status']) {
          print(responseJson);
          setState(() {});
          getTotals();
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
        }
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
        isLoading = false;
      });
    }
  }

  getShippingMethod() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        isLoading = true;
      });
      print(getShippingMethodUrl +
          "&api_token=" +
          preferences.getString(api_token));
      final response = await http.get(
        getShippingMethodUrl + "&api_token=" + preferences.getString(api_token),
        //body: {"shipping_method": "flat.flat"}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if (responseJson['status']) {
          print(responseJson);
          setState(() {
            // isLoading = false;
          });
          setShippingMethod();
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
        }

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
        isLoading = false;
      });
    }
  }
}
