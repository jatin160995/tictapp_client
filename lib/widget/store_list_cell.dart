import 'package:tictapp/screens/store_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/utils/common.dart';

class StoreListCell extends StatefulWidget {

  dynamic storeData;

  StoreListCell(this.storeData);

  @override
  _StoreListCellState createState() => _StoreListCellState();
}

class _StoreListCellState extends State<StoreListCell> {




  void _sendDataToStoreScreen(BuildContext context) {
    dynamic textToSend = widget.storeData;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoreDetail(widget.storeData['id']),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        /*Navigator.of(context).push(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => Signup()
            )
        );*/
        currentStoreId = widget.storeData['id'];
        _sendDataToStoreScreen(context);
        //isLoggedIn();
        //Navigator.pushNamed(context, '/storeDetail');
      },
      child: Container(
        color: background,
        padding: EdgeInsets.all( 10),
        margin: EdgeInsets.only(top: 2),
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 2,
                  child: new Container(
                      width: 80.0,
                      height: 80.0,
                      padding: EdgeInsets.all(5),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.png',
                        image: getImage(),
                      ),
                  ),
                ),
                SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text(widget.storeData['store_name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightText,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 3,),
                    Container(
                      //margin: EdgeInsets.only(left: 15, right: 15),
                      child: Text(widget.storeData['store_address'],
                      //textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: lightestText,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 3,),
                    Row(
                      children: <Widget>[
                        Text("8:00 am - 8:00 pm",
                        //textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: lightestText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getImage()
  {
    //print(widget.storeData['custom_attributes'][0]['value'].toString());

   /* try {

    } on Exception catch (_) {
      print('never reached');
    }*/
    if(widget.storeData['store_logo'].toString() != "null")
    {
      return  widget.storeData['store_logo'];
    }
    else
      {
        return 'https://';
      }
  }
}
