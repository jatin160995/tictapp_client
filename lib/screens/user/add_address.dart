import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/user/address_book.dart';
//import 'package:stripe_payment/stripe_payment.dart';


class AddAddress extends StatefulWidget {

  dynamic oldAddress ;
  String titleIdentifier;

  AddAddress(this.oldAddress, this.titleIdentifier);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  @override
  void initState()
  {
    askPermission ();
    getValuesFromLocal();
    currentLocation();
    super.initState();
    
  }

  String fName = '';
  String lName = '';
  String zip = '';
  String streetAddress = '';
  String company = '';
  String email = '';
  String city = '';
  String state = '';
  String country = 'Panama';
  String phoneNumber = '';
  String comment = '';
  String dateString = '';

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();


  bool isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;
  //Token _paymentToken;
  //PaymentMethod _paymentMethod;
  final String _currentSecret = null; //set this yourself, e.g using curl
  //PaymentIntentResult _paymentIntent;
  //Source _source;

 // ScrollController _controller = ScrollController();

  void setError(dynamic error) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
      print(_error);
    });
  }


double lat =0;
double lng = 0;
void currentLocation() async 
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15.5)));
    });
    //updateLocation();
  }
  


  GoogleMapController _controller ;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.add
   
  }


 askPermission () async {
     Map<Permission, PermissionStatus> statuses = await [
      Permission.location
     ].request();

  setState(() {
    
  });
  }


  String dropdownValue = '';

  TextEditingController countryController = new TextEditingController();
 // final format = DateFormat("dd-MM-yyyy HH:mm:aa");

  final _formKey = GlobalKey<FormState>();
  double mapHeight = 250;
  @override
  Widget build(BuildContext context) {
    zip = savedPostalCode;
    countryController.text = 'Panama';
    state = 'Ontario';
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Add new address',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: mapHeight,
              child: GoogleMap(
              //markers: markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 15.5),
              onCameraMove: ((pinPosition) 
              {
               // print(pinPosition.target.latitude);
                //print(pinPosition.target.longitude);
                lat = pinPosition.target.latitude;
                lng = pinPosition.target.longitude;
              }),
              //myLocationEnabled: true,
              
          ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: mapHeight,
              child: Center(
                child: Container(
                  height: 45,
                  width: 45,
                  child: Image.asset("assets/images/map_marker.png"))//Icon(Icons.pin_drop, size: 40,color: primaryColor,)
              )
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(

              margin: EdgeInsets.only(top: mapHeight),
                          child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column
                  (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text('',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkText,
                          fontSize: 18,

                        ),
                      ),
                    ),

                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              controller: fnameController,
                              onChanged: (text){
                                //password = text;
                                fName = text;
                              },
                              cursorColor: primaryColor,
                              decoration: new InputDecoration(
                                focusedBorder:OutlineInputBorder
                                  (
                                  borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                labelText: "First name",
                                labelStyle: TextStyle
                                  (
                                    color: Colors.grey
                                ),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder
                                  (
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide(
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "First name can not be empty";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              controller: lnameController,
                              onChanged: (text){
                                //password = text;
                                lName = text;
                              },
                              cursorColor: primaryColor,
                              decoration: new InputDecoration(
                                focusedBorder:OutlineInputBorder
                                  (
                                  borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                labelText: "Last name",
                                labelStyle: TextStyle
                                  (
                                    color: Colors.grey
                                ),
                                fillColor: Colors.white,
                                border: new OutlineInputBorder
                                  (
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide(
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "Last name cannot be empty";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    /*SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        onChanged: (text){
                          //password = text;
                          email = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Email cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),*/

                    /*SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        onChanged: (text){
                          //password = text;
                          company = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Company",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Company cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),*/
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        onChanged: (text){
                          //password = text;
                          streetAddress = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Street Address",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Street Address cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        onChanged: (text){
                          //password = text;
                          city = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "City",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "City cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Text('State/Province',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        )),
                    SizedBox(
                      //width: double.infinity,
                      child: Container(
                        //width: 200,
                        child:
                        FlatButton(
                          onPressed: (){showCouponModal();}, child: Text(provinceArray[selectitem]+" ▼"))
                        /*DropdownButton<String>(
                          value: 'Ontario',
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 8,
                          style: TextStyle(color: darkText),
                          underline: Container(
                            height: 2,
                            color: transparent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              state = newValue;
                              //driverTip = calculateDriverTip(double.parse(newValue));
                              //print(newValue);
                            });
                          },
                          items: ['Ontario']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value ),
                            );
                          }).toList(),
                        ),*/

                        /*TextFormField(
                          onChanged: (text){
                            //password = text;
                            state = text;
                          },
                          cursorColor: primaryColor,
                          decoration: new InputDecoration(
                            focusedBorder:OutlineInputBorder
                              (
                              borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            labelText: "State/Povince",
                            labelStyle: TextStyle
                              (
                                color: Colors.grey
                            ),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder
                              (
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0) {
                              return "Street Address cannot be empty";
                            }else{
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                            fontSize: 14,
                          ),
                        ),*/
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        initialValue: savedPostalCode,
                        onChanged: (text){
                          //password = text;
                          zip = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Zip / Postal Code",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Zip/Postal Code cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        //controller: countryController,
                        onChanged: (text){
                          //password = text;
                          country = text;
                        },
                        enabled: false,
                        initialValue: 'Panama',
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Country",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Country cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      child: TextFormField(
                        controller: phoneController,
                        //controller: countryController,
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          //password = text;
                          phoneNumber = text;
                        },
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          focusedBorder:OutlineInputBorder
                            (
                            borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          labelText: "Phone number",
                          labelStyle: TextStyle
                            (
                              color: Colors.grey
                          ),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder
                            (
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {
                            return "Phone number cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),

                   


                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8)
                        ),
                        color: primaryColor,
                        onPressed: ()
                        {

                          /*StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
                            //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
                            setState(() {
                              _paymentMethod = paymentMethod;
                              sendDataToServer();

                            });
                          }).catchError(setError);*/
                          //sendDataToServer();
                          FocusScope.of(context).requestFocus(FocusNode());
                          getToken();
                        },
                        textColor: white,
                        child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text("CONTINUE"),
                      ),
                    ),
                    SizedBox(height: 50,),


                  ],
                ),
              )
          ],
        ),
      ),
            ),
          )
        ],
      )
    );


  }


  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }


  




  void getValuesFromLocal() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      fnameController.text = preferences.getString(firstname ?? '');
      lnameController.text = preferences.getString(lastname ?? '');
      phoneController.text = preferences.getString(savedtelephone ?? '');
      setState(() {
        
      });
       //   , preferences.getString(savedEmail ?? '')
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }


  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      sendDataToServer(preferences.getString(user_token ?? ''), preferences.getString(firstname ?? ''),
          preferences.getString(lastname ?? ''), preferences.getString(savedEmail ?? ''));
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }

dynamic provinceArray = ['Darién Province', "Colón Province", "Coclé Province", 'Chiriquí Province', 'Bocas del Toro Province',
 'Emberá-Wounaan Comarca', 'Guna Yala', 'Herrera Province', 'Los Santos Province', 'Ngöbe-Buglé Comarca',
 'Panamá Oeste Province', 'Panamá Province', 'Veraguas Province'];
dynamic provinceIdArray = ['4243', "4242", '4241', '4240', '4239', '4244', '4245', '4246', '4247', '4248',
'4249', '4250', '4251'];



int selectitem = 0;
showCouponModal()
  {
    showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context,) {
              return CupertinoPicker(
      magnification: 1.5,
      backgroundColor: Colors.black87,
      children: 
        getProvienceText(),
       
      
   
      itemExtent: 50, //height of each item
      looping: true,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectitem = index;
        });  
      
      },
      );
    
              }
              );
  }

  List <Widget> getProvienceText()
  {
    List<Widget> provienceTextList = new List();
    for (int i= 0; i < provinceArray.length; i++)
    {
      provienceTextList.add(Container(
        child: Text(provinceArray[i],
         style: TextStyle(
           color: white
         ))));
      
    }
    return provienceTextList;
  }
  


  Future<void> sendDataToServer(String token, String saveFName, String savedLname, String fromlocalEmail) async {


     var preferences = await SharedPreferences.getInstance();
    if (_formKey.currentState.validate()) {

     /* Map addressInfo = { "addressInformation": { "shippingAddress": { "country_id": "CA", "street": [ streetAddress ], "company": company, "telephone": phoneNumber, "postcode": zip, "city": city, "region": state, "region_id": '74',  "firstname": fName, "lastname": lName, "email": email, "sameAsBilling": 1 },
        "billingAddress": { "country_id": "CA", "street": [ streetAddress ], "company":company, "telephone": phoneNumber, "postcode": zip , "city": city,"region": state, "region_id": '74', "firstname": fName, "lastname": lName, "email": email }, "shipping_method_code": "flatrate", "shipping_carrier_code": "flatrate" } };
*/
     
      Map addressToSend = {
       
          "email": fromlocalEmail,
          "firstname": fnameController.text,
          "lastname": lnameController.text,
          "address_1": streetAddress,
          "address_2": streetAddress,
          "postcode" : zip,
          "city": city,
          "zone_id": provinceIdArray[selectitem],
          "zone" : provinceArray[selectitem],
          "country_id": "164",
          "customer_id": preferences.getInt(id).toString(),
          "latitude": lat.toString(),
          "longitude" : lng.toString()
        
      };
      try
      {
        print(addressToSend);
        print(addAddressURl);
        //return;

        setState(() {
          isLoading = true;
        });
        final response = await http.post(
            addAddressURl+"&api_token="+preferences.getString(api_token),
             // headers: {HttpHeaders.authorizationHeader: "Bearer "+ token,
             // HttpHeaders.contentTypeHeader: contentType},
            body: addressToSend
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          
          final responseJson = json.decode(response.body);
            if(responseJson['status'])
        {
          print(responseJson);
          addressList = responseJson['addresses'] as List;
          addressListToSend = responseJson['addresses'] ;
          Navigator.pop(context);
          Navigator.pop(context);
           Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressBook(widget.titleIdentifier)
                  ));
        }
        else
        {
          showToast("Something went wrong");
          
        }
          
                   
          //getCartId(token);
        }
        else
        {
          //showToast('Something went wrong');
          print(response.statusCode);
          final responseJson = json.decode(response.body);
          print(responseJson);
          showToast(responseJson['error']);
          //loginInfoFromLocal();
          setState(() {
            isLoading = false;
          });
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
    else{
      print('errors');
    }

  }

/*Future<void> getCartId(String token) async {
    print('getCartID');
    setState(() {
      isLoading = true;
      //gettingCartId = true;
    });
    print(createCartId);
    final response = await http.get(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: "Bearer "+token,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
      //gettingCartId = false;
    });

    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      //cartId = responseJson.to;

      //assignCartToUser(token);
      //addItemToCart();


      addItemToCart(responseJson['id'].toString(), token );
      print(responseJson);
    }
    else
    {
      setState(() {
        isLoading = false;
        //gettingCartId = false;
      });
      final responseJson = json.decode(response.body);
      showToast(responseJson['message']);
    }
  }


  int itemReqCounter = 0;

  Future<void> addItemToCart( String cartId, String token) async {
    try{
      print(cartId);

      //dynamic itemArray = new Map();

      Map abc = { "cartItem" : {'sku': cartList[itemReqCounter]['sku'], "qty" : cartList[itemReqCounter]['quantity'], "quoteId" : cartId }};
      setState(() {
        isLoading = true;
      });

      print(itemToCartURL(cartId));
      print(json.encode(abc));
      final response = await http.post(
          itemToCartURL(cartId),
          headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(abc)
      );

      setState(() {
        isLoading = false;
      });
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        itemReqCounter++;
        if(itemReqCounter == cartList.length)
        {
          Navigator.pushReplacementNamed(context, '/orderDetail');
        }
        else{

          addItemToCart(cartId, token);
        }


      }
      else
      {
        print(response.statusCode);
        final responseJson = json.decode(response.body);
        print(responseJson);
        showToast(responseJson['message']);
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
*/
/*
  Future<void> assignCartToUser(String Token) async {
    if (_formKey.currentState.validate()) {
      try
      {print('payment method');
        //print(addressInfo);
        setState(() {
          isLoading = true;
        });
        Map cartInfo = {
          "customerId": userInfoObject['id'],
          "storeId": userInfoObject['store_id']
        };

        final response = await http.put(
            paymentMethod+cartId,
            headers: {HttpHeaders.authorizationHeader: 'Bearer '+ Token,
              HttpHeaders.contentTypeHeader: contentType},
            body: json.encode(cartInfo)
        );
        //response.add(utf8.encode(json.encode(itemInfo)));

        if(response.statusCode == 200)
        {
          final responseJson = json.decode(response.body);
          print(responseJson);
          if(responseJson == true)
          {
            isLoading = false;
            addressAdded = true;
            Navigator.pushReplacementNamed(context, '/orderDetail');
          }
          //createOrder(responseJson);

        }
        else
        {
          final responseJson = json.decode(response.body);
          showToast(responseJson['message']);
          setState(() {
            isLoading = false;
          });
        }

      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
    else{
      print('errors');
    }

  }*/

/*Future<void> createOrder(dynamic paymentMethodMap) async {
    if (_formKey.currentState.validate()) {
      try
      {
        print('createOrder');
      //print(addressInfo);
      setState(() {
        isLoading = true;
      });

      Map orderInfo = {
        "paymentMethod": {
          "method": "stripe_payments",
          "additional_data": {
            "token": (_paymentMethod?.toJson() ?? {})['id']
          }
        }
      };
      print(paymentMethod+cartId+'/order');
      //return;
      final response = await http.put(
        paymentMethod+cartId+'/order',
        headers: {HttpHeaders.authorizationHeader: auth,
          HttpHeaders.contentTypeHeader: contentType},
        body: json.encode(orderInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
      }
      else
      {
        showToast('Something went wrong');
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        print(responseJson);
      }
      setState(() {
        isLoading = false;
      });
      }
      catch(e){
        print(e);
        setState(() {
          isLoading = false;
        });}
    }
    else{
      print('errors');
    }

  }
*/


}
