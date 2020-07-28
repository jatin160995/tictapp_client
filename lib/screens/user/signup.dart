import 'dart:convert';
import 'dart:io';

import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/screens/webview_screen.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Signup',
          style: TextStyle(fontWeight: FontWeight.bold, color: darkText),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 60,),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Form(
              key: signUpKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Join Tictapp today!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkText,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'Create an account to start shopping',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: lightestText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            onChanged: (text) {
                              //password = text;
                              fName = text;
                            },
                            cursorColor: primaryColor,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "First name",
                              labelStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "First name can not be empty";
                              } else {
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
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: TextFormField(
                            onChanged: (text) {
                              //password = text;
                              lName = text;
                            },
                            cursorColor: primaryColor,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              labelText: "Last name",
                              labelStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            validator: (val) {
                              if (val.length == 0) {
                                return "Last name cannot be empty";
                              } else {
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
                      onChanged: (text) {
                        //password = text;
                        email = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Email cannot be empty";
                        } else {
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
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        //password = text;
                        phoneNumber = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Phone number",
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Phone number cannot be empty";
                        } else {
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
                  SizedBox(height: 10),
                  Container(
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (text) {
                        passwordString = text;
                      },
                      cursorColor: primaryColor,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              WebviewScreen(tandCLink, "Terms & conditions")));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("By clicking on submit you agree ",
                              style:
                                  TextStyle(color: lightestText, fontSize: 12)),
                          Text("Terms & conditions",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              WebviewScreen(privacyLink, "Privacy Policy")));
                    },
                    child: Text("Privacy Policy",
                        style: TextStyle(color: primaryColor, fontSize: 12)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8)),
                      color: primaryColor,
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        signUp();
                      },
                      textColor: white,
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(white),
                            )
                          : Text("SIGNUP"),
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
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  final signUpKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signUp() async {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    if (signUpKey.currentState.validate()) {
      Map mapToSend = {
        "firstname": fName,
        "lastname": lName,
        "email": email,
        "telephone": phoneNumber,
        "password": passwordString,
        "agree": "1"
      };
      ApiProvider _provider = ApiProvider();
      final response = await _provider.post(
          "mycustomer/register&api_token=" + preferences.getString(api_token),
          mapToSend);

      if (response['status']) {
        saveData(response);
        print(response.toString());
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showToast("Something went wrong");
      }
    } else {
      print('errors');
    }
  }

  void saveToken(dynamic data) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
  }

  void saveData(dynamic data) async {
    try {
      var preferences = await SharedPreferences.getInstance();

      print(data);
      print(data['customer_info']['firstname']);
      //return;
      // preferences.setInt(store_id, data['store_id']);
      preferences.setString(username, email);
      preferences.setString(password, passwordString);
      preferences.setBool(is_logged_in, true);
      preferences.setInt(id, int.parse(data['customer_info']['customer_id']));
      preferences.setString(firstname, data['customer_info']['firstname']);
      preferences.setString(lastname, data['customer_info']['lastname']);
      preferences.setString(savedEmail, data['customer_info']['email']);
      preferences.setString(savedtelephone, data['customer_info']["telephone"]);

      Navigator.pop(context);
      Navigator.of(context).push(CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => Profile()));
    } catch (e) {
      showToast("Wrong username or password");
    }

    // loginRequest();

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }
}
