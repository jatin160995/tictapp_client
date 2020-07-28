import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/user/profile.dart';
import 'package:tictapp/screens/user/signup.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  String identifier;

  SignIn(this.identifier);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String usernameString = '';
  String passwordString = '';

  final signInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Signin',
          style: TextStyle(fontWeight: FontWeight.bold, color: darkText),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 60,),
            Center(
              child: Text(
                'Signin to Tictapp!',
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
                'Signin to start shopping',
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
            Form(
              key: signInKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      enabled: isLoading ? false : true,
                      onChanged: (text) {
                        usernameString = text;
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
                      enabled: isLoading ? false : true,
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
                ],
              ),
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
                  //loginRequest();
                  signIn();
                },
                textColor: white,
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(white),
                      )
                    : Text("SIGNIN"),
              ),
            ),
            /* SizedBox(height: 10,),
        FlatButton(
          onPressed:()
          {
            Navigator.of(context).push(
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ForgotPassword()
                )
            );
          },
          child: Text("Forgot Password"),
        ),*/

            Container(
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
                        child: Text(
                          'OR',
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
              onTap: () {
                Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    fullscreenDialog: true, builder: (context) => Signup()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have account? ',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: lightestText,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    ' SignUp',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isLoading = false;
  Future<void> signIn() async {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    if (signInKey.currentState.validate()) {
      Map mapToSend = {"email": usernameString, "password": passwordString};
      ApiProvider _provider = ApiProvider();
      final response = await _provider.post(
          "customerlogin&api_token=" + preferences.getString(api_token),
          mapToSend);

      if (response['status']) {
        saveData(response);
        print(response.toString());
        setState(() {
          isLoading = false;
        });
      } else {
        print(response.toString());
        showToast("Wrong username or password");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('errors');
    }
  }

  void saveData(dynamic data) async {
    try {
      var preferences = await SharedPreferences.getInstance();

      print(data);
      print(data['customer_info']['firstname']);
      //return;
      // preferences.setInt(store_id, data['store_id']);
      preferences.setString(username, usernameString);
      preferences.setString(password, passwordString);
      preferences.setBool(is_logged_in, true);
      preferences.setInt(id, int.parse(data['customer_info']['customer_id']));
      preferences.setString(firstname, data['customer_info']['firstname']);
      preferences.setString(lastname, data['customer_info']['lastname']);
      preferences.setString(savedEmail, data['customer_info']['email']);
      preferences.setString(savedtelephone, data['customer_info']["telephone"]);
      if(widget.identifier == "finish")
      {
         Navigator.pop(context);
      }
      else
      {
        Navigator.pop(context);
      Navigator.of(context).push(CupertinoPageRoute(
          fullscreenDialog: true, builder: (context) => Profile()));
      }
      
    } catch (e) {
      showToast("Wrong username or password");
    }

    // loginRequest();

    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }
}
