import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/widget/product.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/screens/categories.dart';

typedef StateCallback = void Function();

class HorizontalProductList extends StatefulWidget {
  dynamic categoryData;
  dynamic categoryId;
  dynamic categoryName;
  dynamic imageUrl;

  HorizontalProductList(
      this.categoryData, this.categoryId, this.categoryName, this.imageUrl);

  @override
  _HorizontalProductListState createState() => _HorizontalProductListState();
}

class _HorizontalProductListState extends State<HorizontalProductList> {
  bool isError = false;
  dynamic productFromServer = new List();

  void _sendDataToCategoryScreen(BuildContext context) {
    dynamic textToSend = widget.categoryData;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Categories(
            categoryList: textToSend,
          ),
        ));
  }

  refresh() {
    /*this.setState(() {
      print('horizontal');

      //products[i]['quantity'] = '1';
      //cartList.add(products[i]);
    });*/
  }

  List<Widget> createProduct(List products) {
    List<Widget> productList = new List();

    if(isLoading)
    {
      productList.add(Container(
            width: MediaQuery.of(context).size.width,
            child: Center(child: Image.asset('assets/images/loading.gif'))));
    }
    else
    {
      if (products.length > 0) {
            for (int i = 0; i < products.length; i++) {
              if (products[i]['image'] == widget.imageUrl) {
                continue;
              }
              productList.add(Product(products[i], true));
            }
          }
          else
          {
          productList.add(Container(
            margin: EdgeInsets.only(left: 15, top: 50),
            child: Text('No Product Avaiable')));
          }
    }
    

    /* try {


    } on Exception catch (_) {

      print('never reached');
    }
*/
    return productList;
  }

  @override
  void initState() {
    super.initState();
    getProducts();

    print(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.categoryName,
                  style: TextStyle(
                      color: darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              GestureDetector(
                onTap: () {
                  widget.categoryData == 1
                      ? null
                      : _sendDataToCategoryScreen(context);
                },
                child: Text(widget.categoryData == 1 ? '' : 'View more >',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
              )
            ],
          ),
        ),
        Container(
          height: 250,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: createProduct(productFromServer)),
        )
      ],
    );
  }

  bool isLoading = false;

  Future<void> getProducts() async {
    isLoading = true;
    try {
      print(getProductUrl);
      print({"key": apiKey, "page": "1", "category_id": widget.categoryId});
      var preferences = await SharedPreferences.getInstance();
      final response = await http.post(getProductUrl+"&api_token=" + preferences.getString(api_token), body: {
       // "key": apiKey,
        "page": "1",
        "category_id": widget.categoryId.toString()
      });
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        //print(responseJson.toString() + "hello");

        if (responseJson['status']) {
          productFromServer.addAll(responseJson['data'] as List); //;
          setState(() {
            isError = false;
            isLoading = false;
            print('setstate');
          });
        } else {
          setState(() {
            productFromServer = new List();
            isLoading = false;
          });
          //showToast("Something went wrong");
        }
        //print("hello");

      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      //showToast('Something went wrong');
    }
  }
}

/*()
{
widget.productData['quantity'] = '1';
cartList.add(widget.productData);
}*/
