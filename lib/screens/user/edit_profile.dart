import 'dart:convert';
import 'dart:io';

import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  String fName = '';
  String lName = '';
  String zip = '';
  String streetAddress = '';
  String company = '';
  String email = '';
  String city = '';
  String state = '';
  String country = 'Canada';
  String phoneNumber = '';
  String passwordString = '';

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();


  @override
  void initState() {
    phoneController.text = '';
   

    fnameController.text = userInfoObject['firstname'];
    lnameController.text = userInfoObject['lastname'];
    emailController.text = userInfoObject['email'];
    phoneController.text = userInfoObject['telephone'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    //String phoneNumber = '';
     


    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Profile',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Form(
              key: signUpKey,
              child: Column
                (
                children: <Widget>[
                 /* Center(
                    child: Text('Join LanesOpen today!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 18,

                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Center(
                    child: Text('Create an account to start shopping',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: lightestText,
                        fontSize: 14,

                      ),
                    ),
                  ),*/
                  SizedBox(height: 15,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            controller:  fnameController,
                            //initialValue: userInfoObject['firstname'],
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
                            controller:  lnameController,
                            //initialValue: userInfoObject['lastname'],
                            onChanged: (text){
                              //password = text;
                              lName  = text;
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
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      controller:  emailController,
                      //initialValue: userInfoObject['email'],
                      onChanged: (text){
                        //password = text;
                        email  = text;
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
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      controller:  phoneController,
                      //initialValue: phoneNumber,
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
                  /*SizedBox(height: 10),
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
                      //initialValue: savedPostalCode,
                      onChanged: (text){
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
                  ),*/
                  /*SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (text){
                        passwordString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder:OutlineInputBorder
                          (
                          borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Password",
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
                          return "Password cannot be empty";
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
                  SizedBox(height: 10,),
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
                        //signUp();
                        FocusScope.of(context).requestFocus(FocusNode());
                        sendDataToServer();
                      },
                      textColor: white,
                      child: isLoading? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color> (white),) : Text("SUBMIT"),
                    ),
                  ),

                  /*Container(
                margin: EdgeInsets.all(40),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Divider(
                          thickness: 1,

                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text('OR',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: lightestText,
                              fontSize: 14,

                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Divider(
                          thickness: 1,

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SignIn('finish')
                      )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: lightestText,
                        fontSize: 14,

                      ),
                    ),
                Text(' SignIn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 14,


                  ),)
                  ],
                ),
              )*/
                ],
              ),
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }

  final signUpKey = GlobalKey<FormState>();
  bool isLoading = false;



  Future<void> sendDataToServer() async {


     var preferences = await SharedPreferences.getInstance();
    if (signUpKey.currentState.validate()) {

     /* Map addressInfo = { "addressInformation": { "shippingAddress": { "country_id": "CA", "street": [ streetAddress ], "company": company, "telephone": phoneNumber, "postcode": zip, "city": city, "region": state, "region_id": '74',  "firstname": fName, "lastname": lName, "email": email, "sameAsBilling": 1 },
        "billingAddress": { "country_id": "CA", "street": [ streetAddress ], "company":company, "telephone": phoneNumber, "postcode": zip , "city": city,"region": state, "region_id": '74', "firstname": fName, "lastname": lName, "email": email }, "shipping_method_code": "flatrate", "shipping_carrier_code": "flatrate" } };
*/
     
      Map addressToSend = {
       
          "email": emailController.text,
          "firstname": fnameController.text,
          "lastname": lnameController.text,
          "telephone": phoneController.text,
          "customer_id": (preferences.getInt(id)).toString()
        
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
            editProfileUrl+"&api_token="+preferences.getString(api_token),
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
          preferences.setString(firstname, fnameController.text);
          preferences.setString(lastname, lnameController.text);
          preferences.setString(savedEmail, emailController.text);
          preferences.setString(savedtelephone, phoneController.text);
          Navigator.pop(context);
          Navigator.pop(context);
           Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => Profile()));
          
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



  


}
