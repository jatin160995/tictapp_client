import 'dart:convert';
import 'dart:io';
import 'package:tictapp/screens/user/signin.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/screens/product_detail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Product extends StatefulWidget {


  dynamic productData;

  Product(this.productData);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {


  bool isLoading = false;


  void _sendDataToProductDetailScreen(BuildContext context) {
    dynamic textToSend = widget.productData;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(productData: textToSend,),
        ));
  }

  @override
  Widget build(BuildContext context) {

    //print(widget.productData);
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Stack(
        children: <Widget>[
          
          GestureDetector(
            onTap: ()
            {
              _sendDataToProductDetailScreen(context);
            },
            child: Container(
              color: white,
              child: Row(
                children: <Widget>[
                  Container(
                    color: white,
                    margin: EdgeInsets.only(left: 10, right: 5),
                    child: Stack(
                      
                      children: <Widget>[
                        isLoading?
                        
                         Align
                          (
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage.assetNetwork(
                              height: 100,
                              width: 100,
                              placeholder: 'assets/images/loading.png',
                              image: ""//widget.productData['custom_attributes'][0]['value'],
                            ),
                          ),
                        ): Container(),
                       
                        Align
                          (
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage.assetNetwork(
                              height: 100,
                              width: 100,
                              placeholder: placeholderImage,
                              image: widget.productData['image'],
                            ),
                          ),
                        ),
                        

                      ],
                    ),

                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(widget.productData['name'],
                              //textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle
                                (
                                  color: darkText,
                                  fontSize: 15
                              )),
                        ),
                        SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: Text(inr + double.parse(widget.productData['price']).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle
                                  (
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    fontSize: 19
                                ))
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed:()
                              {
                                
                                saveCartToLocal(widget.productData);
                              },
                              icon: Icon(Icons.add_shopping_cart,
                                color: primaryColor,
                              ),
                            ),
                        )
                       /* Row(
                          children: <Widget>[
                            IconButton(
                         onPressed: (){},
                         iconSize: 15,
                         icon: Icon(Icons.remove),
                       ),
                      Text("0",
                       style: TextStyle(
                         color: darkText,
                         fontSize: 16
                       )),
                       IconButton(
                         onPressed: (){},
                         color: primaryColor,
                         iconSize: 15,
                         icon: Icon(Icons.add),

                       ),
                          ]
                        )*/
                      ],
                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading?
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: transparentBackground,
              child: Image(
                height: 160,
                width: 160,
                image: AssetImage('assets/images/loading.gif'),
              ),
            ),
          ) : Container(),

           
        ],
      ),
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
        getToken();
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


  void saveData(dynamic data) async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(user_token, data);
    getToken();
    //print(preferences.getString(user_token));
    // var savedValue = preferences.getString('value_key');
  }

  void getToken() async
  {
    try{
      var preferences = await SharedPreferences.getInstance();
      print(preferences.getString(user_token ?? ''));
      addItemToCart(preferences.getInt(cart_id ?? 0));

    }
    catch(e)
    {
      //showToast('Something went wrong');
    }
  }


  void loginInfoFromLocal() async
  {
    setState(() {
      isLoading = true;
    });
    try
    {
      var preferences = await SharedPreferences.getInstance();
      getUserToken(preferences.getString(username ?? ''), preferences.getString(password ?? ''));
    }
    catch(e){
      //showToast("Something went wrong");
    }
  }


  Future<void> getUserToken(String username, String password) async {

    Map addressInfo = { 'username' : "$username", 'password' : "$password"};

    try
    {
      print(loginUrl);
      print(addressInfo);
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
          loginUrl,
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(addressInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        saveData(responseJson);
        print(responseJson.toString());

      }
      else
      {
        final responseJson = json.decode(response.body);
        showToast(responseJson['message']);
        Navigator.pop(context);
        print(response.statusCode);
      }
      setState(() {
        //isLoading = false;
      });
    }
    catch(e){
      print(e);
      setState(() {
        //Navigator.pop(context);
        //showToast("Something went wrong");
      });}


  }

  /*Future<void> getCartId(String token) async {
    print('getCartID');
    setState(() {
      isLoading = true;
      gettingCartId = true;
    });
    final response = await http.post(
      createCartId,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token,
        HttpHeaders.contentTypeHeader: contentType},
    );
    setState(() {
      isLoading = false;
      gettingCartId = false;
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
      setState(() {
        isLoading = false;
        gettingCartId = false;
      });
      final responseJson = json.decode(response.body);
      showToast(responseJson['message']);
    }
  }
*/


  Future<void> addItemToCart(int cart_id) async {
    try{
      print('itemTocart');
      Map itemInfo = { "cartItem" : { "sku" : widget.productData['sku'], "qty" : 1, "quoteId" : cart_id } };
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          itemToCartURL(cartId),
          headers: {HttpHeaders.authorizationHeader: auth,
            HttpHeaders.contentTypeHeader: contentType},
          body: json.encode(itemInfo)
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      setState(() {
        isLoading = false;
      });
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        //cartCount++;
        //cartId = responseJson;
        //widget.productData['quantity'] = '1';
        updateCart();
        skuList.add(widget.productData['sku']);
        imageList.add( widget.productData['custom_attributes'][0]['value']);

        print(responseJson);
      }
      else
      {
        final responseJson = json.decode(response.body);
        print(responseJson);
        loginInfoFromLocal();
        showToast(responseJson['message']);
      }
    }
    catch(e)
    {
      setState(() {
        isLoading = false;
      });
      //showToast('Something went wrong');
      print(e);
    }
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
      //showToast('Something went wrong');
    }
  }
}
