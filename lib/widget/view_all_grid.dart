import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/product_half_screen.dart';


class ViewAllProductGrid extends StatefulWidget {
  dynamic catInfo;


  ViewAllProductGrid(this.catInfo);

  @override
  _ViewAllProductGridState createState() => _ViewAllProductGridState();
}

class _ViewAllProductGridState extends State<ViewAllProductGrid> with AutomaticKeepAliveClientMixin<ViewAllProductGrid> {

  bool isError = false;
  dynamic productFromServer = new List();

  ScrollController controller;
  int currentPage = 1;

  void _scrollListener() {
    /*if (controller.position.pixels == controller.position.maxScrollExtent) {
      //startLoader();
      setState(() {
        currentPage ++;
        getProducts();
      });

      print('hello');
    }*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return /*new ListView(
      children: createProduct(),
      controller: controller,
    );*/
    GridView.count(
      primary: false,
      padding: const EdgeInsets.all(15),
      childAspectRatio: (160 / 220),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      controller: controller,
      children: createProduct(),
    );
  }


  List<Widget> createProduct()
  {
    List<Widget> productList = new List();


    if(isLoading)
    {
      productList.add(Container(width: MediaQuery.of(context).size.width,child: Center(child: Image.asset('assets/images/loading.gif'))));
    }
    else
    {
      if(productFromServer.length == 0)
      {
         productList.add(Container(
           margin:EdgeInsets.only(top: 50) ,
           child: Center(child: Text('No Product Avaiable'))));
      }
      else{
        for(int i =0; i < productFromServer.length; i++)
      {
        productList.add(Product(productFromServer[i], false));
      }
      }
    }
    
    /* try {


    } on Exception catch (_) {

      print('never reached');
    }
*/
    return productList;
  }

  bool isLoading = false;
  Future<void> getProducts() async {


    isLoading = true;
    try
    {
      print(getProductPro);
       print(widget.catInfo['category_id']);
        var preferences = await SharedPreferences.getInstance();
     final response = await http.post(
          getProductPro+"&api_token=" + preferences.getString(api_token),
          body: {"key": apiKey, "page": currentPage.toString(), "category_id" : widget.catInfo['category_id'].toString(), "store_id":openedStoreId}
      );
      print(json.decode(response.body));
      if(response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        print(responseJson.toString() + "hello");
        if (responseJson['status']) {
          print("hello");
        productFromServer.addAll(responseJson['data'] as List); //;
        setState(() {
          isError = false;
          isLoading = false;
          print('setstate');
        });
        } 
        else {
          setState(() {
            productFromServer = new List();
            isLoading = false;
          });
          showToast("Something went wrong");
        }

        
      }
      else
      {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    }
    catch(e)
    {
      setState(() {
          isError = true;
          isLoading = false;
        });
      productFromServer = new List();
      showToast('Something went wrong');
    }


  }



  @override
  bool get wantKeepAlive => true;
}
