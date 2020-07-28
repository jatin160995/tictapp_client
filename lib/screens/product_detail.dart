import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:tictapp/screens/user/signin.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/utils/common.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';
import 'package:tictapp/widget/updates/horizontal_product_list_from_server.dart';


class ProductDetail extends StatefulWidget {


  dynamic productData;

  ProductDetail({Key key, @required this.productData}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}


class _ProductDetailState extends State<ProductDetail> {




  int countFromLocal = 0;
  bool isCartIUpdated = false;
  void getCartCount() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(preferences.getString(user_token ?? ''));
      countFromLocal =  preferences.getInt(cart_count ?? 0);
      if(!isCartIUpdated)
      {
        setState(() {
         // isCartIUpdated = true;
        });
      }

    }
    catch(e)
    {
      showToast('Error while getting cart count');
      countFromLocal = 0;
    }
  }
  @override
  Widget build(BuildContext context) {
    //getCartCount();
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          Navigator.pushNamed(context, '/cart');
        },
        backgroundColor: primaryColor,
        child: Badge(
          badgeContent: Text(
            countFromLocal.toString(),
            style: TextStyle(
                color: white
            ),),
          child: Icon(Icons.shopping_cart, size: 25),
        ),
      ),*/
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: bottomTabHeight),
            child: ListView(
        children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      child: Container(
                        child: Hero(
                          tag: widget.productData['image'],
                            child: FadeInImage.assetNetwork(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                            placeholder: 'assets/images/loading.png',
                            image:widget.productData['image'],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 40, left: 15),
                        decoration: new BoxDecoration(
                            color: lightGrey,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                              bottomRight: const Radius.circular(40.0),
                              bottomLeft: const Radius.circular(40.0),
                            )
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                    widget.productData['name'],
                    style: TextStyle(
                        color: darkText,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    inr + double.parse(widget.productData['price']).toStringAsFixed(2),
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Availability: ',
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        ),
                      ),
                      Text(
                        widget.productData['stock_status'] ,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'SKU: ',
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        ),
                      ),
                      Text(
                        widget.productData['sku'] ,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: primaryColor,
                        width: 150,
                        child: FlatButton(
                          onPressed: ()
                          {
                            //widget.productData['quantity'] = '1';
                            //cartList.add(widget.productData);
                            /*cartId == '' ?
                            getCartId() : addItemToCart();*/
                           // isLoggedIn();

                            setState(() {
                             /// cartCount++;
                             saveCartToLocal(widget.productData);
                            });
                            /*setState(() {
                              bool isFound = false;
                              for(var item in cartList ){
                                if(widget.productData["sku"] == item['sku'])
                                {
                                  print(item['name']);
                                  item['quantity'] = item['quantity'] + 1;
                                  isFound = true;
                                  //break;
                                }
                              }
                              if(!isFound)
                              {
                                widget.productData['quantity'] = 1;
                                cartList.add(widget.productData);
                              }
                              cartCount ++;
                            });*/

                          },
                          child: isLoading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(white),): Text('Add To Cart',
                            style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                 Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text(
                           widget.productData['description'].toString().replaceAll("&quot;", "").replaceAll("&amp;", "&"),
                          style: TextStyle(
                              color: lightestText,
                              fontWeight: FontWeight.normal,
                              fontSize: 14
                          ),
                        ),
                ),
                SizedBox(height: 10,),
                HorizontalProductList(1, widget.productData['category_id'],'Related Products', widget.productData['image'])
              ],
            ),
        ],
      ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomTabs(1, true),
          )
        ],
      )
    );
  }



  void isLoggedIn() async
  {
    var preferences = await SharedPreferences.getInstance();
    //preferences.getBool(is_logged_in ?? false);
    try
    {
      if(!preferences.getBool(is_logged_in ?? false))
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => SignIn( 'finish'),
            ));
      }
      else
      {
        ///Navigator.pushReplacementNamed(context, '/home');
        addItemToCart();
      }
    }
    catch(e){
      Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => SignIn( 'finish'),
          ));
      print("exception");}

    //return preferences.getBool(is_logged_in ?? false);
  }

  bool isLoading = false;
  Future<void> getCartId() async {
    print('getCartID');
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
    });
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      cartId = responseJson;

      addItemToCart();
      print(responseJson);
    }
    else
    {
      showToast('Something went wrong');
    }
  }



  Future<void> addItemToCart() async {

  }

  void updateCart() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      //print(preferences.getString(user_token ?? ''));
      int updatedCount = preferences.getInt(cart_count ?? 0) +1;
      setState(() {
        preferences.setInt(cart_count, updatedCount);
      });
    }
    catch(e)
    {
      showToast('Something went wrong');
    }
  }



}
