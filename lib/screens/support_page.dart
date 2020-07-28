import "package:flutter/material.dart";
import 'package:tictapp/screens/chat/chat.dart';
import 'package:tictapp/screens/live_van.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomTabs(4, true),
      backgroundColor: white,
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text("Support",
            style: TextStyle(
              color: darkText
            )
            ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: white,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                GestureDetector(
                  onTap: (){
                    _makePhoneCall();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.call, color: Colors.amber),
                      SizedBox(width: 15,),
                      Text("Call",
                      style: TextStyle(
                        color: lightText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                      
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(height: 15),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat("testChat"),
                        ));
                    },
                    child: Row(
                    children: <Widget>[
                      Icon(Icons.message, color: Colors.blueAccent),
                      SizedBox(width: 15,),
                      Text("Chat",
                      style: TextStyle(
                        color: lightText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                      
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(height: 15),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: ()
                  {
                    openWhatsApp();
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                         // margin: EdgeInsets.only(top: 40, left: 15, bottom: 90),
                         //color: white,
                          padding: EdgeInsets.all(5),
                          decoration: new BoxDecoration(
                                color: Colors.green[300],
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(40.0),
                                  topRight: const Radius.circular(40.0),
                                  bottomRight: const Radius.circular(40.0),
                                  bottomLeft: const Radius.circular(40.0),
                                )
                          ),
                          child: Container(
                              height: 17,
                              width:17,
                              child: Image.asset("assets/images/whatsapp.png"))
                        ),
                      SizedBox(width: 15,),
                      Text("WhatsApp",
                      style: TextStyle(
                        color: lightText,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
                      
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(height: 15),
              ],

            ),
          )
        ],
      ),
    );
  }

  openWhatsApp() async
    {
      var whatsappUrl ="whatsapp://send?phone="+mobileNumber;
      await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
    }

     Future<void> _makePhoneCall() async {
    if (await canLaunch('tel:'+mobileNumber)) {
      await launch('tel:'+mobileNumber);
    } else {
      throw 'Could not launch $mobileNumber';
    }
  }
}