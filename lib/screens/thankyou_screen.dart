import "package:flutter/material.dart";
import 'package:tictapp/utils/common.dart';

class ThankyouScreen extends StatefulWidget {
  @override
  _ThankyouScreenState createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {

    Future<bool> _onWillPop() async {
      Navigator.of(context).popUntil((route) => route.isFirst);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
          child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: darkText),
          backgroundColor: white,
          title: Text("Order Placed Successfully",
          style: TextStyle(
            color: darkText
          )),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 80),
              child: 
              Image.asset("assets/images/confirm.png")
            ),
            SizedBox(height: 30,),
            Text("Your order has been placed",
            style: TextStyle(
              color: darkText,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10,),
             Text("Thank you for shopping with us.",
            style: TextStyle(
              color: lightText,
              fontSize: 14,
              fontWeight: FontWeight.normal
            ),),
            SizedBox(height: 10,),
            FlatButton(
              color: primaryColor,
              onPressed: (){
               Navigator.of(context).popUntil((route) => route.isFirst);
            }, 
            child: Text(
              "Continue Shopping  >",
            style: TextStyle(
              color: white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),)),
            Expanded(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(bottom: 10),
                      child: 
                        Image.asset("assets/images/loading.png")
                       ),
                    ),
                  ],
                )
            ),
          ],
        ),

      ),
    );
  }
}