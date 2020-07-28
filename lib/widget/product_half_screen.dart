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
  bool pushREplace;

  Product(this.productData, this.pushREplace);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {


  bool isLoading = false;


  void _sendDataToProductDetailScreen(BuildContext context) {
    dynamic textToSend = widget.productData;
    if(widget.pushREplace)
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(productData: textToSend,),
        ));
    }
    else
    {
Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetail(productData: textToSend,),
        ));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    double cellWidth = MediaQuery.of(context).size.width;
    //print(widget.productData);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: ()
          {
            _sendDataToProductDetailScreen(context);
          },
          child: Container(
            color: white,
            width: cellWidth/2,
            child: Column(
              children: <Widget>[
                Container(
                  color: white,
                  width: cellWidth/2,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Stack(
                    children: <Widget>[
                      isLoading? Align
                        (
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage.assetNetwork(
                            height: cellWidth/2,
                            width: cellWidth/2,
                            placeholder: 'assets/images/loading.png',
                            image: "widget.productData['image']"//widget.productData['custom_attributes'][0]['value'],
                          ),
                        ),
                      ): Container(),
                      Align
                        (
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FadeInImage.assetNetwork(
                          height: (cellWidth/2)- 60,
                          width: (cellWidth/2)- 60,
                          placeholder: placeholderImage,
                          image: widget.productData['image'],
                            ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed:()
                            {
                              if(storeIdInCart == "0" || cartTemporary.length == 0 || storeIdInCart == openedStoreId)
                              {
                                saveCartToLocal(widget.productData);
                                
                              }
                              else
                              {
                                cartDialog();
                              }
                              
                              
                            },
                            icon: Icon(Icons.add,
                            size: 27,
                              color: primaryColor,
                            ),
                          )
                      ),

                    ],
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                  child: Text(widget.productData['name'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle
                        (
                          color: lightestText,
                          fontSize: 13
                      )),
                ),
                SizedBox(height: 5,),
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
              image: AssetImage(placeholderImage),
            ),
          ),
        ) : Container()
      ],
    );
  }



  void cartDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Icon(Icons.block, color: Colors.red, size: 35),
          content: Wrap(
            children: <Widget>[
              new Text("You can't add product from different store.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                              child: FlatButton(
                  onPressed: ()
                  {
                    Navigator.of(context).pop();
                  },
                  child: Text("Continue Shopping",
                  style: TextStyle(
                    color: white
                  ),),
                  color: primaryColor
                ),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            /*new FlatButton(
              child: new Text("Go To Cart",
              style: TextStyle(
                color: darkText
              ),),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("OK",
                style: TextStyle(
                    color: primaryColor
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),*/

          ],
        );
      },
    );
  }

 
  


}
