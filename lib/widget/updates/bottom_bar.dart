import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/screens/cart.dart';
import 'package:tictapp/screens/live_van.dart';
import 'package:tictapp/screens/search.dart';
import 'package:tictapp/screens/store_detail.dart';
import 'package:tictapp/screens/support_page.dart';
import 'package:tictapp/screens/updates/all_category.dart';
import 'package:tictapp/utils/common.dart';

class BottomTabs extends StatefulWidget {

  int index;
  bool showCat;

  BottomTabs(this.index, this.showCat);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
Timer timer ;

int countCart= 0;

  void startTimer()
  {
    timer = new Timer.periodic(Duration(seconds: 2), (timer) { 
      setState(() {
        countCart = 0;
        for(var pro in cartTemporary)
        {
          countCart = countCart + pro['quantity'];
          //print(pro['quantity']);
        }
      });
     });
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomTabHeight,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              children: <Widget>[
                 SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: transparentBlack,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),

        Align(
          child: Container(
            alignment: Alignment.topCenter,
          height: bottomTabHeight,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 5),
          color: white,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    //Navigator.popUntil(context, StoreDetail(null));
                    if(widget.index == 1)
                    {
                     // return;
                    }
                    else
                    {
                     // Navigator.pop(context);
                    }
                   Navigator.of(context).popUntil((route) => route.isFirst);
                   // Navigator.popUntil(context, ModalRoute.withName('/store'));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.home, color: widget.index == 1 ? primaryColor : lightestText,),
                      Text('Home',
                        style: TextStyle(
                            color: widget.index == 1 ? primaryColor : lightestText,
                            fontSize: 12
                        ),)
                    ],
                  ),
                ),
              ),

             /* widget.showCat ? Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    if(widget.index == 2)
                    {
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategories(),
                        ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                     // Icon(Icons.category, color:  widget.index == 2 ? primaryColor : lightestText,),
                     Container(
                       height: 25,
                       width: 25,
                       padding: EdgeInsets.all(3),
                       child: ColorFiltered(
                         colorFilter: ColorFilter.mode(widget.index == 2 ? primaryColor : lightestText, BlendMode.srcATop),
                         child: Image.asset("assets/images/category_icon.png"),
                       ),
                     ),
                      Text('Categories',
                        style: TextStyle(
                            color: widget.index == 2 ? primaryColor : lightestText,
                            fontSize: 12
                        ),)
                    ],
                  ),
                ),
              ) : Container(),*/
              
             /* Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: ()
                  {
                    if(widget.index == 3)
                    {
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveVan(),
                        ));
                  },
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.airport_shuttle,color:  widget.index == 3 ? primaryColor : lightestText,),
                     // Icon(Icons.shopping_cart, color:  index == 4 ? primaryColor : lightestText,),
                      Text('Live van',
                        style: TextStyle(
                            color: widget.index == 3 ? primaryColor : lightestText,
                            fontSize: 12
                        ),)
                    ],
                  ),
                ),
              ),*/
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportScreen(),
                        ));
                  },
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Icon(Icons.call, color:  widget.index == 4 ? primaryColor : lightestText,),
                      Container(
                       height: 25,
                       width: 25,
                       padding: EdgeInsets.all(2),
                       child: ColorFiltered(
                         colorFilter: ColorFilter.mode(widget.index == 4 ? primaryColor : lightestText, BlendMode.srcATop),
                         child: Image.asset("assets/images/support.png"),
                       ),
                     ),
                      Text('Support',
                        style: TextStyle(
                            color:   widget.index == 4 ? primaryColor : lightestText,
                            fontSize: 12
                        ),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Cart()//Search( widget.storeData['id'].toString()),
                          ));
                  },
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Badge(
                        badgeContent: Text(
                          countCart.toString(),
                        style: TextStyle(
                            color: white
                        ),),
                        child: Container(
                       height: 25,
                       width: 25,
                       padding: EdgeInsets.all(1),
                       child: ColorFiltered(
                         colorFilter: ColorFilter.mode(widget.index == 5 ? primaryColor : lightestText, BlendMode.srcATop),
                         child: Image.asset("assets/images/cart_icon.png"),
                       ),
                     ),//Icon(Icons.shopping_cart,color:  widget.index == 5 ? primaryColor : lightestText,),
                      ),
                     // Icon(Icons.shopping_cart, color:  index == 4 ? primaryColor : lightestText,),
                      Text('Cart',
                        style: TextStyle(
                            color: widget.index == 5 ? primaryColor : lightestText,
                            fontSize: 12
                        ),)
                    ],
                  ),
                ),
              ),
              
            ],
          ),
      ),
        )
        ],
      ),
    );
  }
}
