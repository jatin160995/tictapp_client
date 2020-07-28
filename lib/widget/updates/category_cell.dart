import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:tictapp/screens/categories.dart';
import 'package:tictapp/utils/common.dart';

class CategoryCell extends StatefulWidget {
  dynamic categoryData;
  CategoryCell(this.categoryData);

  @override
  _CategoryCellState createState() => _CategoryCellState();
}

class _CategoryCellState extends State<CategoryCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: ExpandablePanel(
        header: Container(
          height: 50,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                    width: 50,
                    padding: EdgeInsets.all(5.0),
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    
                    placeholder: 'assets/images/loading.png',
                    image: widget.categoryData['image']//widget.productData['custom_attributes'][0]['value'],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.categoryData['name'].toString().replaceAll("&amp;", "&"),
                    style: TextStyle(
                        fontSize: 16,
                        color: lightText,
                        fontWeight: FontWeight.bold
                    ),),
                  SizedBox(height: 10,),
                  Text(widget.categoryData["description"],
                    style: TextStyle(
                        fontSize: 13,
                        color: lightestText,
                        fontWeight: FontWeight.normal
                    ),),
                ],
              ),
            ],
          ),
        ),
        expanded: Container(
          color: white,
          margin: EdgeInsets.only(left: 0, right: 0, top: 5),
          child: Container(
            child: Column(
              children: getSubCategories(widget.categoryData['children']),
            ),
          ),
        ),
        tapHeaderToExpand: true,
        hasIcon: true,
      ),
    );
  }




   List<Widget> getSubCategories(dynamic subcatList)
  {
    List<Widget> subcatWidgetList = new List();
    for (int i= 0; i < subcatList.length; i++)
    {
      subcatWidgetList.add(GestureDetector(
              onTap: ()
              {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Categories(categoryList: subcatList[i],),
                  ));
              },
              child: new Container(
                color: white,
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Text(subcatList[i]["name"].replaceAll("&amp;", "&"),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: darkText,
                                  fontWeight: FontWeight.normal
                              ),),
                            Icon(Icons.arrow_forward_ios,
                              color: lightestText, size: 13,)
                          ],
                        ),
                        Divider(height:30,)
                      ],
                    ),
                  ),
      ));
    }

    return subcatWidgetList;
  }
}
