import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictapp/screens/thankyou_screen.dart';
import 'package:tictapp/utils/common.dart';
import 'package:http/http.dart' as http;


class PaymentDetails extends StatefulWidget {

  String tip_code;
  PaymentDetails(this.tip_code);
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {

 ExpandableController dateTimeController =  new ExpandableController();
 ExpandableController commentController =  new ExpandableController();
 TextEditingController instructionController = new TextEditingController();
  @override
  void initState() {
     getPaymentMethod();
     dateTimeController.expanded = true;
     commentController.expanded = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.tip_code);
    return Scaffold(
      backgroundColor: white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: darkText
          ),
          backgroundColor: white,
          title: Text("Just a step away",
          style: TextStyle
          (
            color: darkText
          )),
          centerTitle: true,
        ),
        body:isLoading? Center(
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              height: 100,
                              width: 100,
                              child: Image.asset(placeholderImage)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Loading...")
                        ],
                      ),
                    ],
                  ),
                )  : ListView(
          children: <Widget>[
            Container(
            color: white,
           // padding: EdgeInsets.all(15),
            //margin: EdgeInsets.only(left:15, right: 15),
            child: ExpandablePanel(
              
              controller: dateTimeController,
              header: Container(
                margin: EdgeInsets.only(top: 15, left: 15),
                child: Text("Choose Delivery Date",
                  style: TextStyle(
                    fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              collapsed: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(DateFormat('EEE').format(getSelectedDate()).toUpperCase() + " (" +
                    DateFormat('MMM').format(getSelectedDate()) + " " + DateFormat('dd').format(getSelectedDate())+")"
                  , softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              ),
              expanded: Container(
                // height: 180,
                margin: EdgeInsets.only(top: 10),
                color: white,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: createDateTimeLayout(),
                )
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
          //Divider(),
          SizedBox(height: 20,),
          Container(
            color: white,
           // padding: EdgeInsets.all(15),
           // margin: EdgeInsets.only(left:15, right: 15, top: 15),
            child: ExpandablePanel(
              controller: commentController,
              header: Container(
                margin: EdgeInsets.only(top: 15, left: 15, bottom: 20),
                child: Text("Delivery Instructions",
                  style: TextStyle(
                      fontSize: 16,
                      color: darkText,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              expanded: Container(
                color: white,
                              child: Container(
                  color: white,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: instructionController,
                    keyboardType: TextInputType.text,
                    onChanged: (text){
                      //password = text;
                      //comment = text;
                    },
                    cursorColor: primaryColor,
                    decoration: new InputDecoration(
                      focusedBorder:OutlineInputBorder
                        (
                        borderSide: const BorderSide(color:  Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: "Delivery Instruction (Optional)",
                      labelStyle: TextStyle
                        (
                          color: Colors.grey
                      ),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder
                        (
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Comment cannot be empty";
                      }else{
                        return null;
                      }
                    },
                    style: new TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ),
          SizedBox(height: 15),
            Container(
              color: white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createPaymentCell(),
              ),
            )
          ],
        ),
    );
  }


  List<Widget> createDateTimeLayout()
  {
    List<Widget> widgetList = new List();
    widgetList.add(Container(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: createNextDaysDate(),
      ),
    ),);
    widgetList.add(
      Divider(height: 1,)
    );
    widgetList.add(
      SizedBox(height: 10,)
    );
    widgetList.add(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          
                "Select a time",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:FontWeight.normal,
                  color: lightestText
                ),
              ),
      )
    );
    widgetList.add(
      Column(
        children:  createTimeSlots(),
      )
    );
    //widgetList.add(SizedBox(height: 20,),);

    return widgetList;
  }





  int selectedTimeSlot = 0;
  String selectedTimeSlotString = "";
  List<Widget> createTimeSlots()
  {
    List<Widget> widgetList = new List();
    String year = getSelectedDate().year.toString();
    String month = getSelectedDate().month.toString();
    String day =getSelectedDate().day.toString();

    if(int.parse(month) <= 9)
    month = "0"+month;

    if(int.parse(day) <= 9)
    day = "0"+day;
    

    dynamic timeSlotObject = dateTimeArray['data'][year+"-"+
      month+"-"+day] ;
      print(year+"-"+
      month+"-"+day);
      print(timeSlotObject);
      List slots = timeSlotObject['slots'];
    for (int i = 0 ; i < slots.length; i ++)
    {

      if(i == selectedTimeSlot){  
          selectedTimeSlotString = slots[i]['from'];
          if(slots[i]['to'] != "")
          {
            selectedTimeSlotString = selectedTimeSlotString+ "  -  "+slots[i]['to'];
          }
        }
        print(selectedTimeSlotString);
      widgetList.add(GestureDetector(
        onTap: ()
        {
          setState(() {
            selectedTimeSlot = i;
          });
        },
              child: Container(
          color: i ==selectedTimeSlot ? greenBackground : white,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                slots[i]['from']+"  -  "+slots[i]['to'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:  FontWeight.normal,
                  color: i ==selectedTimeSlot ? primaryColor: lightestText
                ),
              ),
               Text(
                slots[i]['cost'] == "" ? "Free" : slots[i]['cost'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal ,
                  color: i ==selectedTimeSlot ? primaryColor: lightestText
                ),
              )
            ],
          ),
        ),
      ));
    }
    return widgetList;
  }


int currentSelectedDate = 0;
List<Widget> createNextDaysDate()
  {
    List<Widget> dateCellList = new List();
    var today = new DateTime.now();

    for(int i = 0; i < 7; i ++)
    {
      var nextDate = today.add(new Duration(days: i));
      dateCellList.add(Container(
        //margin: EdgeInsets.only(top: 10, left: 0, right: 0),
        height: 70,
        width: 1,
        color: dividerColor
      ));
      dateCellList.add(GestureDetector(
        onTap: (){
          setState(() {
            currentSelectedDate = i ;
            
            selectedTimeSlot = 0;
          });
          },
        child: new Container(
          height: 70,
          width: 120,
          color: currentSelectedDate == i ? greenBackground: white,
          //margin: EdgeInsets.only(top: 10, left: 0, right: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             Text( i == 0 ? "TODAY" : i== 1 ? "TOMORROW" :  DateFormat('EEE').format(nextDate).toUpperCase(),
              style: TextStyle(
                color: currentSelectedDate == i ? primaryColor : primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
              Text(DateFormat('MMM').format(nextDate) + " "+ DateFormat('dd').format(nextDate),
                style: TextStyle(
                    color:  currentSelectedDate == i ? primaryColor : primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),)
            ],
          ),
        ),
      ));
    }
    return dateCellList;
  }

DateTime getSelectedDate()
  {
    var today = new DateTime.now();
    var nextDate = today.add(new Duration(days: currentSelectedDate));
    return nextDate;
  }
  List<Widget> createPaymentCell() 
  {
    List<Widget> singleMEthod = new List();
    singleMEthod.add( Container(
      margin: EdgeInsets.all(15),
      //color: background,
      child: Text("Choose Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                        color: darkText,
                        fontWeight: FontWeight.bold
                    ),),
    ),);
    if(paymentMethodList.length> 0)
    {
          for (int i = 0; i < paymentMethodList.length; i++)
        {
          singleMEthod.add(Container(
            color: white,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                        onTap: ()
                        {
                          setPaymentMethod(paymentMethodList[i]['code']);
                          
                        },
                        child: Container(height: 50,
                        padding: EdgeInsets.only(top: 0, left: 15),
                        color: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(paymentMethodList[i]['title'],
                            
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                            Text(">   ",
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),
                          ],
                        )),
                ),
                      Divider(),
              ],
            ),
          ));
        }
    }
    else
    {
      singleMEthod.add(new Container(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/loading.gif'),
        ));
    }
    
    return singleMEthod;
    
  }

  bool isTimeLoading = true;
  dynamic dateTimeArray ;
  getTimeSlots() async 
  {
  var preferences = await SharedPreferences.getInstance();
  DateTime todayDate = DateTime.now();
     try {
      setState(() {
        isLoading = true;
      });
      Map infoToSend =  {"date": todayDate.year.toString()+"-"+
      todayDate.month.toString()+"-"+todayDate.day.toString()};
      print(infoToSend);
      print(getTimingSlots+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          getTimingSlots+"&api_token="+preferences.getString(api_token),
          body: infoToSend
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if(responseJson['status'])
        {
          print(responseJson);
          setState(() {
              isLoading = false;
            dateTimeArray = responseJson;
            });
            //setUserDetailToSession();
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }

        
        
       
        //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    }
    catch (e) {
      print(e);
      setState(() {
        isTimeLoading = false;
      });
  }
  }
















  setPaymentMethod(String paymentMethod) async 
  {
  var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      Map infoToSend =  {"payment_method": paymentMethod};
      print(infoToSend);
      print(setPaymentMethodUrl+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          setPaymentMethodUrl+"&api_token="+preferences.getString(api_token),
          body: infoToSend
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if(responseJson['status'])
        {
          print(responseJson);
          setState(() {
              //isLoading = false;
            
            });
            setUserDetailToSession();
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }

        
        
       
        //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
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



  
 




  bool isLoading = false;
  List paymentMethodList = new List();
  getPaymentMethod() async
  {
    
    var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      print(getPaymentMethodUrl+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          getPaymentMethodUrl+"&api_token="+preferences.getString(api_token),
          body: {"customer_id": (preferences.getInt(id).toString())}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if(responseJson['status'])
        {
          paymentMethodList = responseJson['payment_methods'];
        
        print(responseJson);
        setState(() {
            isLoading = false;
           
          });
          getTimeSlots();
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }
        
        
        
        //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
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



setUserDetailToSession() async 
  {
 var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      print(setCustomerToSessionUrl+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          setCustomerToSessionUrl+"&api_token="+preferences.getString(api_token),
          body: {"firstname": preferences.getString(firstname), 
                 "lastname":preferences.getString(lastname),
                 "email":preferences.getString(savedEmail),
                 "telephone":preferences.getString(savedtelephone),
                 "customer_id":(preferences.getInt(id)).toString(),}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        if(responseJson['status'])
        {
        createOrder();
        print(responseJson);
        setState(() {
          // isLoading = false;
          
          });
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }
        
        
         //print(responseJson);
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
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





  createOrder() async 
  {
 var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      print(createOrderUrl+"&api_token="+preferences.getString(api_token));
      print({
            'delivery_date': getSelectedDate().year.toString()+"-"+getSelectedDate().month.toString()+"-"+getSelectedDate().day.toString(),
            'delivery_time': selectedTimeSlotString,
            'addtipchkavailtip': widget.tip_code,
            'addtipchkflag': "1",
            'comment': instructionController.text,
            'store_id': openedStoreId
});
      final response = await http.post(
          createOrderUrl+"&api_token="+preferences.getString(api_token),
          body: {
            'delivery_date': getSelectedDate().year.toString()+"-"+getSelectedDate().month.toString()+"-"+getSelectedDate().day.toString(),
            'delivery_time': selectedTimeSlotString,
            'addtipchkavailtip': widget.tip_code,
            'addtipchkflag': "1",
            'comment': instructionController.text,
            'store_id': openedStoreId
}
      );
      //response.add(utf8.encode(json.encode(itemInfo))); 

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if(responseJson['status'])
        {
          print(responseJson);
        setState(() {
            isLoading = false;
           
          });
          cartTemporary.clear();
          Navigator.pop(context);
          Navigator.pop(context);
           Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => ThankyouScreen()));
        //print(responseJson);
        }
        else
        {
          setState(() {
              isLoading = false;});
          showToast("Something went wrong");
          
        }

       
      }
      else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        Navigator.pop(context);
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