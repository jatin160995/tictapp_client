import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/utils/common.dart';
import 'package:tictapp/widget/updates/bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:tictapp/widget/updates/category_cell.dart';


class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {

  @override
  void initState() {
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        iconTheme: IconThemeData(color: darkText),
        title: Text('Categories',
          style: TextStyle(
              color: darkText
          ),),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: bottomTabHeight),
            child:isLoading ? Image.asset("assets/images/loading.gif"): ListView(
              children: getListData()
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomTabs(1, true),
          )
        ],
      ),

    );
  }



  List<Widget> getListData()
  {
    List<Widget> widgetList = new List();
    if(categoryList.length > 0){
      for(int i =0; i < categoryList.length; i ++)
      {
        widgetList.add(CategoryCell(categoryList[i]));
      }
    }
    return widgetList;

  }

  bool isLoading = false;
  List categoryList = new List();
  Future<void> getCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      var preferences = await SharedPreferences.getInstance();
      //print(getCatUrl+"&api_token=" + preferences.getString(api_token));
      final response = await http.post(
          getCatUrl+"&api_token=" + preferences.getString(api_token),
          body: {"store_id": currentStoreId}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if(responseJson['status'])
        {
        categoryList = responseJson['categories'] as List;
        print(categoryList.length);
        setState(() {
            isLoading = false;
          });
        print(responseJson);
        }
        else
        {
          showToast("Something went wrong");
          Navigator.pop(context);
        }
       
       
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
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
