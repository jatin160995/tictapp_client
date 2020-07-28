import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/order_detail.dart';
import 'package:tictapp/screens/user/address_book.dart';
import 'package:tictapp/screens/user/signin.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/cart_product_cell.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  void initState() {
   //getCartList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomTabs(5, true),
      backgroundColor: white,
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(
          color: darkText
        ),
        centerTitle: true,
        backgroundColor: white,
        title: Text('Cart',
        style: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView(
        children: createProduct(cartTemporary)
          
      ),
    );
  }

List cartFromLocal = new List();



isLoggedIn() async
{
  var preferences = await SharedPreferences.getInstance();
  try
  {
    if(preferences.getBool(is_logged_in ?? false) )
    {
      getData();
      //createCartOnServer();
    }
    else
    {
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SignIn("finish") ));
    }
  }
  catch(e)
  {
      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => SignIn("finish") ));
  }
}


ApiProvider _provider = ApiProvider();
  getData() async {
    //print("hello");
    setState(() {
        isLoading =true;
      });
    final response = await _provider
        .post("login", {"key": apiKey, "username": website_username});
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(api_token, response["api_token"]);
    print(response.toString());
    createCartOnServer();
  
  }

bool isLoading = false;
createCartOnServer() async
{
  var preferences = await SharedPreferences.getInstance();
  try{
      setState(() {
        isLoading =true;
      });
      List listToSend = new List();
      for(var singleProd in cartTemporary)
      {
        Map singleProdMap  = {  
          "product_id":singleProd["product_id"],
          "quantity":singleProd['quantity'],
          "customer_id": preferences.getInt(id)
	      };
        listToSend.add(singleProdMap);
      }
        ApiProvider _provider = ApiProvider();
        final response = await _provider.postJsonToServer("cart/add&api_token="+preferences.getString(api_token), json.encode(listToSend));
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => AddressBook("Select Address")));
        print(response);
        setState(() {
        isLoading =false;
      });

  }
  catch(e)
  {
    print(e);
  }
  



}

List<Widget> createProduct(dynamic cartListFromLocal) 
{
  double subtotal = 0;
  List<Widget> productList = new List();
  if(cartListFromLocal.length > 0)
  {
    for (int i = 0; i < cartListFromLocal.length; i++)
  {
    print(cartListFromLocal[i]);
    subtotal = subtotal + double.parse(cartListFromLocal[i]['price']) * double.parse(cartListFromLocal[i]['quantity'].toString());
    productList.add(CartProductCell(
            productData :cartListFromLocal[i],
            addQuant: (){
             setState(() {
               cartListFromLocal[i]['quantity'] = cartListFromLocal[i]['quantity'] + 1;
             });
            },
            delQuant: ()
            {
              setState(() {
                if(cartListFromLocal[i]['quantity'] > 1)
                {
                  cartListFromLocal[i]['quantity'] = cartListFromLocal[i]['quantity'] - 1;
                }
               
             });
            },
          delItem: ()
          {
            setState(() {
               cartListFromLocal.removeAt(i);
             });
          },
        ));
  }
    productList.add(Container(
      color: lightGrey,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('SubTotal:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                  cartOnHold ? Container(height: 15, width: 15, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),) :
                  Text('\$' + subtotal.toStringAsFixed(2),// /*+ calculateDriverTip(double.parse(dropdownValue)) + shipping + calculateDriverTip(serviceFeePercent)*/).toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
                ]
              ),
    ));
    productList.add(
      Container(
        height: 45,
          color: primaryColor,
          margin: EdgeInsets.all(15),
        child: new FlatButton(onPressed: 
          (){
            isLoggedIn();
          }, 
          child: 
          isLoading? CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(white)):
              Text("Checkout",
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),)
        ),
      )
    );
    productList.add(SizedBox(height: 50,));
  }
  else
  {
    productList.add(
      new Container(
          height: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              children: <Widget>[
                Container(
                  child: Icon(Icons.add_shopping_cart, size: 80, color: iconColor,)
                ),
                SizedBox(height: 20),
                Text('Cart is empty!',
                 style:  TextStyle(
                   color: iconColor,
                   fontWeight: FontWeight.normal,
                   fontSize: 22
                 ),),
                
              ],
            ),
          )
        )
    );
  }
  

  return productList;
}
  





}