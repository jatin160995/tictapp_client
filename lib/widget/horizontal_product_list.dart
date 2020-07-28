import 'dart:convert';
import 'dart:io';

import 'package:tictapp/screens/view_all_product.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/widget/product.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/screens/categories.dart';

typedef StateCallback = void Function();
class HorizontalProductList extends StatefulWidget {

  dynamic categoryData;
  dynamic productsObject;
  dynamic categoryName;


  HorizontalProductList(this.categoryData, this.productsObject, this.categoryName);


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
          builder: (context) => Categories(categoryList: textToSend,),
        ));
  }

  refresh()
  {
    /*this.setState(() {
      print('horizontal');

      //products[i]['quantity'] = '1';
      //cartList.add(products[i]);
    });*/

  }

  List<Widget> createProduct(List products)
  {

    // print(products.length);
    List<Widget> productList = new List();
    try{

    if(products.length > 0){
      for(int i =0; i < products.length; i++)
      {
        productList.add(Product(products[i], false));
      }
    }
    else {
        if(!isError)
          productList.add(Container(width: MediaQuery.of(context).size.width,child: Center(child: Image.asset('assets/images/loading.gif'))));
        else
          productList.add(Container(
              margin: EdgeInsets.only(left: 15, top: 50),
              child: Text('No Product Avaiable')
          ));
      }
    }
    catch(e)
    {
      print(e);
    }

    return productList;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getProducts();

    print("hello"+widget.productsObject.toString());
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
              Text(widget.categoryName.toString().replaceAll("&amp;", "&"),
              style: TextStyle(
                color: darkText,
                fontWeight: FontWeight.bold,
                fontSize: 16
              )),
              GestureDetector(
                onTap: ()
                {
                  dynamic dataTosendArray = {
                    'name': widget.categoryName,
                    'category_id': widget.productsObject['category_id']
                  };
                  List<dynamic> jsonArray = new List();
                  jsonArray.add(dataTosendArray);
                  dynamic dataTosend = {
                    "name": widget.categoryName,
                    "category_id":  widget.productsObject['category_id'],
                    "children": jsonArray
                  };
                  print(dataTosend);
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllProduct(categoryList: dataTosend,),
                  ));
                 // widget.categoryData == 1 ? null : _sendDataToCategoryScreen(context);
                },
                child: Text(
                    'View more >',
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14
                    )),
              )
            ],
          ),
        ),
        Container(
          height: 250,
          child: ListView(

            scrollDirection: Axis.horizontal,
            children: createProduct(getItems())
          ),
        )
      ],
    );
  }

List getItems()
{
  List itemList = new List(0);

  try
  {
    itemList = widget.productsObject['items'] as List;
  }
  catch(e)
  {
    print(e);
    itemList = new List(0);
  }
  return itemList;
}

}




/*()
{
widget.productData['quantity'] = '1';
cartList.add(widget.productData);
}*/
