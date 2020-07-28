import 'dart:convert';
import 'dart:io';

//import 'package:tictapp/screens/user/address_book.dart';
//import 'package:tictapp/screens/user/change_password.dart';
//import 'package:tictapp/screens/user/edit_profile.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/user/address_book.dart';
import 'package:tictapp/screens/user/change_password.dart';
import 'package:tictapp/screens/user/edit_profile.dart';
import 'package:tictapp/screens/user/my_orders.dart';
import 'package:tictapp/screens/webview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


dynamic userInfoObjectToSend = '';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginInfoFromLocal();
  }
  @override
  Widget build(BuildContext context) {


    

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: darkText
        ),
        backgroundColor: white,
        centerTitle: true,
        title: Text('Profile',
         style: TextStyle(
           color: darkText,
           fontWeight: FontWeight.bold
         ),
        ),
      ),
      body: isLoading  ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(placeholderImage)),
              ) : Container(
        padding: EdgeInsets.all(10),
        child: ListView(children: <Widget>[
          Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10,),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Account Infromation',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                    ),
                    SizedBox(height: 15,),
                    Text('Name',
                      style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.normal,
                          fontSize: 12
                      ),
                    ),
                    Text(userInfoObject['firstname'] + " "+ userInfoObject['lastname'] ,
                      style: TextStyle(
                          color: lightText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text('Email',
                      style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.normal,
                          fontSize: 12
                      ),
                    ),
                    Text(userInfoObject['email'],
                      style: TextStyle(
                          color: lightText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text('Phone',
                      style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.normal,
                          fontSize: 12
                      ),
                    ),
                    Text( userInfoObject['telephone'],
                      style: TextStyle(
                          color: lightText,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Options',
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                      ),
                    ),
                    SizedBox(height: 18,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ));
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Edit Profile',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     Divider(),
                    //SizedBox(height: 18,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePassword(),
                            ));
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Change Password',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => MyOrders()));
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.library_books, color: lightestText,),
                            SizedBox(width: 20),
                            Text('My Orders',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddressBook("Address Book")
                            )
                        );
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_city, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Address Book',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => WebviewScreen(tandCLink, "Terms & conditions")
                      )
                   );
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(

                          children: <Widget>[
                            Icon(Icons.assignment_turned_in, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Terms & Conditions',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                       Navigator.of(context).push(
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => WebviewScreen(privacyLink, "Privacy Policy")
                      )
                  );
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(

                          children: <Widget>[
                            Icon(Icons.vpn_lock, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Privacy Policy',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: (){
                        logoutDialog();
                      },
                      child: Container(
                        color: white,
                        height: 40,
                        child: Row(

                          children: <Widget>[
                            Icon(Icons.exit_to_app, color: lightestText,),
                            SizedBox(width: 20),
                            Text('Logout',
                              style: TextStyle(
                                  color: lightText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                  ],
                ),
              ),
            )
          ],
        ),
      
        ],))
    );
  }








  bool isLoading = false;

  void loginInfoFromLocal() async
  {
    setState(() {
      isLoading = true;
    });
    var preferences = await SharedPreferences.getInstance();
    getUserToken(preferences.getString(username ?? ''), preferences.getString(password ?? ''));
  
  }


  Future<void> getUserToken(String username1, String password) async {

      var preferences = await SharedPreferences.getInstance();
      try
      {
        Map mapToSend = {"email" :  "$username1", "password": "$password"};
        ApiProvider _provider = ApiProvider();
        final response = await _provider.post("customerlogin&api_token="+preferences.getString(api_token),mapToSend);
        
         if(response['status'])
        {
          setState(() {
                    isLoading = false;
                    userInfoObject = response['customer_info'];
                  });
        }
        else
        {
          showToast("Something went wrong");
          Navigator.pop(context);
        } 
        
        print (userInfoObject.toString());
    }
    catch(e){
      print(e);
      //showToast('Something went wrong');
      Navigator.pop(context);

    }

  }


  void logoutDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout!"),
          content: new Text("Are you sure, you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
              style: TextStyle(
                color: darkText
              ),),
              onPressed: () {

                Navigator.of(context).pop();
                logout();
              },
            ),
            new FlatButton(
              child: new Text("Cancel",
                style: TextStyle(
                    color: primaryColor
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  void logout() async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, '');
    preferences.setString(username, '');
    preferences.setString(password, '');
    preferences.setInt(store_id, 0);
    preferences.setInt(cart_id, 0);
    preferences.setInt(cart_count, 0);
    preferences.setInt(id, 0);
    preferences.setString(firstname, '');
    preferences.setString(savedEmail, '');
    preferences.setString(lastname, '');
    preferences.setBool(is_logged_in, false);
    userInfoObject = '';
    //Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    //Navigator.popUntil(context, ModalRoute.withName('/home'));
    //Navigator.pop(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

}
