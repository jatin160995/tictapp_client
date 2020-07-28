import 'package:cached_network_image/cached_network_image.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailCell extends StatefulWidget {


  dynamic productData;
  final Function addQuant;
  final Function delQuant;
  final Function delItem;

  OrderDetailCell({this.productData, this.addQuant,this.delQuant,this.delItem});

  @override
  _OrderDetailCellState createState() => _OrderDetailCellState();
}

class _OrderDetailCellState extends State<OrderDetailCell> {

  String dropdownValue = '1';

  List<String> getDropdownValues()
  {
    List<String> drodownValues = new List();
    for(int i =1; i < 100; i++ )
    {
      drodownValues.add(i.toString());
    }
    return drodownValues;
  }


  @override
  void dispose() {

    itemToDelete= 0;
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
  }

  getImage()
{
  String image = "http://";

    try{
      image = widget.productData['image'];//cartProdImages[cartProdTitle.indexOf(widget.productData['name'])];
    }
    catch(e)
    {
      image = "http://";
    }

  return image; 
}

  @override
  Widget build(BuildContext context) {

    //print(widget.productData);
    //dropdownValue = widget.productData['quantity'];
    cartCount = cartCount+ int.parse(widget.productData['quantity']);
    return Container(
      color: white,
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          itemToDelete == widget.productData['item_id'] ? Container(padding: EdgeInsets.all(12.0), height: 43, width: 43,child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor))):
          /*IconButton(
            onPressed: widget.delItem,
            iconSize: 19,
            icon: Icon(Icons.delete, color: transparentREd, ),
          ),*/
           GestureDetector(
            onTap: (){},
            child: Container(
              height: 70,
              width: 70,
              color: lightGrey,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(left: 15),
              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                         Image.asset(placeholderImage),
                                imageUrl: getImage(),
                              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 15, top: 5, right: 15),
                    child: Text(
                      widget.productData['name'],
                      maxLines: 3,
                      style: TextStyle(
                          color: lightestText,
                          fontWeight: FontWeight.normal,
                          fontSize: 13
                      ),
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          widget.productData['price'],
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          ),
                        ),
                    ),
                    SizedBox(width: 30,),
                    Text('x'+ widget.productData['quantity'].toString(),
                        style: TextStyle(
                            color: darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        )),
                   // cartOnHold && updatingItemId ==  widget.productData['item_id']? Container(height: 15, width: 15, child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primaryColor)),) :
                    /*Text(widget.productData['quantity'].toString(),
                        style: TextStyle(
                            color: darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )),*/


                  ],
                ),
                /*Container(
                  child: FlatButton(
                    onPressed: ()
                    {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          //builder: (context) => AddInstruction(widget.productData)
                        )
                      );
                    },
                    child: Row(
                      children: <Widget>[
                       // Icon(Icons.note_add, size: 20,color: primaryColor,),
                        SizedBox(width: 4,),
                        Expanded(
                          child: Text(instructionToShow,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: lightText
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),*/
              ] ,
            ),
          )
        ],
      ),
    );
  }


  String instructionToShow = "Add Notes";
}

/*
* DropdownButton<String>(
                     value: dropdownValue,
                     icon: Icon(Icons.arrow_drop_down),
                     iconSize: 24,
                     elevation: 8,
                     style: TextStyle(color: darkText),
                     underline: Container(
                       height: 2,
                       color: transparent,
                     ),
                     onChanged: (String newValue) {
                       setState(() {
                         dropdownValue = newValue;
                         print('in the cell');
                         //getTap();
                       });
                     },
                     items: getDropdownValues()
                         .map<DropdownMenuItem<String>>((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                   )
* */