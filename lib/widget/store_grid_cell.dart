import 'package:tictapp/screens/store_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/utils/common.dart';

class StoreGridCell extends StatefulWidget {

  dynamic storeData;

  StoreGridCell(this.storeData);

  @override
  _StoreGridCellState createState() => _StoreGridCellState();
}

class _StoreGridCellState extends State<StoreGridCell> {




  void _sendDataToStoreScreen(BuildContext context) {
    dynamic textToSend = widget.storeData;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoreDetail(widget.storeData['id']),
        ));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.storeData);
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
        color: background,//HexColor.fromHex(widget.storeData['background_color']),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: (MediaQuery.of(context).size.width/2),
        width: (MediaQuery.of(context).size.width/2)-20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 2,
              child: new Container(
                  width: (MediaQuery.of(context).size.width/2)-90,
                  height: (MediaQuery.of(context).size.width/2)-90,
                  //padding: EdgeInsets.all(5),
                  color: HexColor.fromHex(widget.storeData['background_color']),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/logo_grey_tictapp.png',
                    image: getImage(),
                  ),
              ),
            ),
            SizedBox(height: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(widget.storeData['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightText,
                      fontSize: 18,
                    ),
                  ),
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
    if(widget.storeData['image'].toString() != "null")
    {
      return  widget.storeData['image'];
    }
    else
      {
        return 'https://';
      }
  }
}
