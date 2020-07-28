import 'package:flutter/material.dart';
import 'package:tictapp/screens/user/user_order_detail.dart';
import 'package:tictapp/utils/common.dart';

class PendingOrderSlider extends StatefulWidget {
  dynamic orderList;
  PendingOrderSlider(this.orderList);

  @override
  _PendingOrderSliderState createState() => _PendingOrderSliderState();
}

class _PendingOrderSliderState extends State<PendingOrderSlider> {

  PageController _controller = PageController(
    initialPage: 0,
);
double currentPage = 0;
@override
  void initState() {
    _controller.addListener(() {
     
      if(_controller.page % 1 == 0)
      {
         print(_controller.page);
setState(() {
        
        currentPage = _controller.page;
      });
      }
      
      
      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 114,
          color:white,
          child: PageView(
            
            //scrollDirection: Axis.vertical,
            controller: _controller,
            children:  createOrders(),
          ),
          
        ),
        Container(height: 10,
        //color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: createDots(),
        )
        )
      ],
    );
  }

List<Widget> createDots()
  {
    List<Widget> dotList = new List();
    for(double i =0; i < widget.orderList.length; i++)
    {
    if(widget.orderList[i.toInt()]['order_status_id'] == "1" || widget.orderList[i.toInt()]['order_status_id'] == "2")
    {
dotList.add(Icon(Icons.radio_button_checked,
             size: 10,
             color:i == currentPage ? Colors.blue[900]: iconColor,),);
    }
      
    }

    return dotList;
  }

  List<Widget> createOrders()
  {
    List<Widget> orderList = new List();
    for(int i =0; i < widget.orderList.length; i++)
    {
     // if(widget.orderList[i]['order_status_id'] == "1" || widget.orderList[i]['order_status_id'] == "2")
      orderList.add(SinglePendingOrder(widget.orderList[i]));
    }

    return orderList;
  }

}



class SinglePendingOrder extends StatefulWidget {
  dynamic data;
  SinglePendingOrder(this.data);
  @override
  _SinglePendingOrderState createState() => _SinglePendingOrderState();
}

class _SinglePendingOrderState extends State<SinglePendingOrder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: false, builder: (BuildContext context) => UserOrderDetail(widget.data['order_id'])));
      },
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  color: Colors.blue[900],
                  padding: EdgeInsets.all(10),
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.data['firstname'] + " "+widget.data['lastname'] ,
                      maxLines: 1,
                      style: TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),),
                      Text(inr+ (double.parse(widget.data['total'])).toStringAsFixed(2),
                        maxLines: 2,
                        style: TextStyle(
                          color: white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),),
                      Text("Store: "+widget.data['store_name_main'],
                      maxLines: 2,
                      style: TextStyle(
                        color: white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),),
                      Text(widget.data['order_status_id_actual'],
                      maxLines: 2,
                      style: TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),),
                      
                    ],
                  ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: Text("Order Id: "+widget.data['order_id'],
                        style: TextStyle(
                          color: white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),),
                  ),
                  Text(widget.data['delivery_date']+"\n"+widget.data['time_slot'],
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                      ),),
                ],
              )
            ],
          ),
                ),
        ),
      ),
    );
  }
}