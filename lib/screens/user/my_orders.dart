import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/user/user_order_detail.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  @override
  void initState() {
    getOrdersFromServer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text("My Orders",
        style: TextStyle(
          color: darkText
        )),
      ),
      body: ListView(
        children: createOrderList()
      ),
    );
  }

  



  List<Widget> createOrderList()
  {
    List<Widget> orderList = new List();
    for (int i =0; i < orderListFromServer.length; i++)
    {
      dynamic singleOrder = orderListFromServer[i];
      if(singleOrder["order_id"].toString() != "null")
      {
      // print(singleOrder);
      orderList.add(UserOrderCell(singleOrder));
      }
      
    }
    if(orderListFromServer.length ==0)
    {
      isLoading ?
       orderList.add(Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(placeholderImage)),
              ) ) 
        :
        orderList.add(new Container(
          height: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                Container(
                  child: Icon(Icons.add_shopping_cart, size: 80, color: iconColor,)
                ),
                SizedBox(height: 20),
                Text('No Orders available',
                 style:  TextStyle(
                   color: iconColor,
                   fontWeight: FontWeight.normal,
                   fontSize: 22
                 ),),
                
              ],
            ),
          )
        ));
    }
    return orderList;
  }


  bool isLoading = false;
  List orderListFromServer = new List();
  getOrdersFromServer() async 
  {
  var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
    
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
        orderListFromServer = responseJson['data'] as List;
        print(orderListFromServer..sort((a, b) => a.length.compareTo(b.length)));
        print(responseJson);
        setState(() {
            isLoading = false;
           
          });
        }
        else
        {
          showToast("Something went wrong");
          setState(() {
            isLoading = false;
           
          });
          
        }
        
        
          // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => ThankyouScreen()));
        //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
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

class UserOrderCell extends StatelessWidget {
  dynamic singleOrder;

  UserOrderCell(this.singleOrder);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: ()
          {
            Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: false, builder: (BuildContext context) => UserOrderDetail(singleOrder['order_id'])));
            //Navigator.of(context).push(CupertinoPageRoute(builder: (context) => UserOrderDetail(singleOrder['order_id'])));
          },
          child: Container(
              padding: EdgeInsets.all(15),
              color: white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Order Id: #"+singleOrder['order_id'],
                          style: TextStyle(
                            color: lightestText,
                            //fontWeight: FontWeight.bold,
                            fontSize: 13
                          )),
                        SizedBox(height: 1),
                        Text(singleOrder['shipping_firstname']+ " "+ singleOrder['shipping_lastname'],
                        style: TextStyle(
                          color: lightText,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 1),
                        Text(singleOrder['order_status_id_actual'],
                        style: TextStyle(
                          color: singleOrder['order_status_id_actual'] ==
                                              "Pending"
                                          ? orange
                                          : singleOrder['order_status_id_actual'] ==
                                                  "Complete"
                                              ? greenButton
                                              : singleOrder['order_status_id_actual'] ==
                                                      "Cancel"
                                                  ? Colors.red
                                                  : Colors.blue,
                          fontSize: 14,
                        ),),

                        
                        

                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                       
                        Text(singleOrder['date_added'].toString().split(" ")[0],
                        style: TextStyle(
                          color: lightestText,
                          fontSize: 13,
                        ),),
                        SizedBox(height: 1),
                        Text(inr+double.parse(singleOrder['total']).toStringAsFixed(2),
                        style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        )),
                        SizedBox(height: 1),
                         Text(singleOrder['payment_method'],
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 12,
                        ),),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}