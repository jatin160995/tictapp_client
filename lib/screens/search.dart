import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/widget/updates/bottom_bar.dart';


class FindItem extends StatefulWidget {

  String storeId;

  FindItem(this.storeId);

  @override
  _FindItemState createState() => _FindItemState();
}

class _FindItemState extends State<FindItem> {


  int currentPage = 1;

  bool ischanged = false;
  TextEditingController textEditingController = new TextEditingController();

  String query = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


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
    return Scaffold(
      bottomNavigationBar: BottomTabs(1, true),
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        iconTheme: IconThemeData(color: darkText),
        title: Text('Search',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkText
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: lightGrey,
            padding: EdgeInsets.all(8),
            child: Card(
              child: Container(
                //padding: EdgeInsets.only(left: 10, right: 10),
                  color: white,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child:TextField(
                            controller: textEditingController,
                            enabled:  true,
                            //textCapitalization: TextCapitalization.characters,
                            onChanged: (text)
                            {

                              query = text;
                              // print(query);
                              ischanged = true;
                            },
                            decoration : InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                            ),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,

                        child: Container(
                            height: 50,
                            decoration: new BoxDecoration(
                              color: primaryColor,
                              borderRadius: new BorderRadius.only(
                                bottomRight: const Radius.circular(4.0),
                                topRight: const Radius.circular(4.0),
                              ),
                            ),
                            child: Center(
                                child: IconButton(
                                  onPressed: (){
                                    print(textEditingController.text);
                                    productFromServer = new List();
                                    currentPage = 1;
                                    getProducts();
                                    FocusScope.of(context).requestFocus(FocusNode());},
                                  icon: Icon(Icons.search),
                                  color: white,
                                )
                            )),
                      ),
                    ],
                  )
              ),
            ),
          ),

          Expanded(
            child:
            GridView.count(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(15),
              childAspectRatio: (160 / 220),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              //controller: controller,
              children: isLoading && currentPage ==1 ? [Center(child: Container(
                  margin:EdgeInsets.only(top: 80),height: 40, width: 40, child: CircularProgressIndicator()))] :getChildren(),
            )

            /*ListView(

                children: isLoading && currentPage ==1 ? [Center(child: Container(
                    margin:EdgeInsets.only(top: 80),height: 40, width: 40, child: CircularProgressIndicator()))] :getChildren()
            ),*/
          )
        ],
      ),
    );
  }


  bool isDialogLoading = false;







  List<Widget> getChildren()
  {
    List<Widget> productList = new List();
    for(int i = 0; i < productFromServer.length; i ++)
    {
      productList.add(new Product(productFromServer[i], false));
    }
    if(productList.length > 0)
    {
      productList.add(new FlatButton(
          onPressed: isLoading? (){} : (){
            currentPage ++;
            productList.remove(productList.length-1);
            productList.add(CircularProgressIndicator());
            setState(() {

            });
            getProducts();

          },
          child: isLoading ? Container( height: 40, width: 40, child: CircularProgressIndicator()): Text('Load More')
      )
      );
    }

    return productList;
  }


  dynamic productFromServer = new List();

  bool isLoading = false;
  Future<void> getProducts() async {

    setState(() {
      isLoading = true;
    });

    print(textEditingController.text);
    try
    {
       print(getProductUrl);
       var preferences = await SharedPreferences.getInstance();
       //print(widget.catInfo['category_id']);
     final response = await http.post(

          searchUrl+"&api_token=" + preferences.getString(api_token),
          body: {"key": apiKey, "page": currentPage.toString(), 'keyword': textEditingController.text,"store_id": widget.storeId}
      );
    //print(json.decode(response.body));
    if(response.statusCode == 200)
    {
      final responseJson = json.decode(response.body);
      if(responseJson['status'])
        {
          // print(responseJson);
          if(currentPage > 1)
          {
          // productFromServer.removeAt(productFromServer.length -1);
          }
          //print(responseJson['items']);
          productFromServer.addAll(responseJson['data'] as List); //;
          // productFromServer.add({'isLast':'1'});
          setState(() {
            isLoading = false;
            //createProduct();
            print('setstate');
          });
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }

       
    }
    else
    {
      setState(() {
        isLoading = false;
      });
    }
    }
    catch(e)
    {
      print(e);
      setState(() {
        isLoading = false;
      });
      showToast('Something went wrong');
    }
  }

}



class SearchedItem extends StatefulWidget {

  dynamic productData;
  Function openDialog;
  SearchedItem(this.productData, this.openDialog);
  @override
  _SearchedItemState createState() => _SearchedItemState();
}

class _SearchedItemState extends State<SearchedItem> {
  @override
  Widget build(BuildContext context) {

    print(widget.productData['custom_attributes'][0]['value']);
    return GestureDetector(
      onTap: widget.openDialog,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(

            children: <Widget>[
              FadeInImage.assetNetwork(
                height: 70,
                width: 70,
                placeholder: 'assets/images/loading.gif',
                image: widget.productData['custom_attributes'][0]['value'],
              ),
              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.productData['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: lightestText,
                          fontSize: 15,
                        )
                    ),
                    SizedBox(height: 5,),
                    Text('\$' + widget.productData['price'].toStringAsFixed(2),

                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

