import 'dart:convert';
import 'dart:io';

import 'package:tictapp/model/ApiProvider.dart';
import 'package:tictapp/screens/cart.dart';
import 'package:tictapp/screens/order_detail.dart';
import 'package:tictapp/screens/user/add_address.dart';
import 'package:tictapp/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


dynamic addressList;
dynamic addressListToSend;

class AddressBook extends StatefulWidget {

  String title;

  AddressBook(this.title);

  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {


   Future<void> getUserToken() async {

setState(() {
                    isLoading = true;
                  });
      var preferences = await SharedPreferences.getInstance();
      try
      {
        Map mapToSend = {"email" : preferences.getString(username ?? ''), "password": preferences.getString(password ?? '')};
        ApiProvider _provider = ApiProvider();
        final response = await _provider.post("customerlogin&api_token="+preferences.getString(api_token),mapToSend);
        
         if(response['status'])
        {
         getAddresses();
        }
        else
        {
          showToast("Something went wrong");
          Navigator.pop(context);
        } 
    }
    catch(e){
      print(e);
      //showToast('Something went wrong');
      Navigator.pop(context);

    }

  }

  @override
  void initState() {
    super.initState();
     
     getUserToken();
     
    //loginInfoFromLocal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
         IconButton(
           icon: Icon(Icons.playlist_add, color: primaryColor,),
            onPressed: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddress(addressListToSend, widget.title),
                  ));
            },
         )

        ],
        iconTheme: IconThemeData(color: darkText),
        backgroundColor: white,
        centerTitle: true,
        title: Text(widget.title,
        style: TextStyle(
          color: darkText,
          fontWeight: FontWeight.bold
        ),
        )
      ),
      body: ListView(
        children: isLoading ? loadingWidget() : getAddressCells()
      ),
    );
  }

  List<Widget> loadingWidget()
  {
    List<Widget> loadingWidgetList = new List();
    loadingWidgetList.add(Center(
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
                ) );
    return loadingWidgetList;
  }

  List<Widget> getAddressCells()
  {
    List<Widget> addressWidgetList = new List();
    for(int i= 0 ;i < addressList.length; i++)
    {
      addressWidgetList.add(AddressCell(addressList[i], widget.title , (){
        setState(() {
         // deleteAddressRequest(addressList[i]['id'], i);
        },);},
              (){
                setState(() {
                 // getUserTokenToAddAddress(addressList[i]);
                 addAddressToOrder(addressList[i]);
                });
              }));
    }
    if(addressList.length == 0)
    {
      addressWidgetList.add(new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text('Address Book is empty!',
              style:  TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 22
              ),),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddAddress(addressListToSend, widget.title)
                    )
                );
              },
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.playlist_add, color: primaryColor,),
                    Text('Add new Address',
                      style:  TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14
                      ),),

                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }


    return addressWidgetList;
  }


List addressList = new List();
  getAddresses() async
  {
    var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      print(getAddressURl+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          getAddressURl+"&api_token="+preferences.getString(api_token),
          body: {"customer_id": (preferences.getInt(id).toString())}
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        addressList = responseJson['addresses'] as List;
        print(responseJson);
        setState(() {
            isLoading = false;
           
          });
        //print(responseJson);
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



  bool isLoading = false;



addAddressToOrder(dynamic address) async 
{
   var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      Map addressToSend = {
          "firstname": address['firstname'],
          "lastname": address['lastname'],
          "address_1": address['address_1'],
          "address_2": address['address_2'],
          "postcode" : address['postcode'],
          "city": address['city'],
          "zone_id": address['zone_id'],
          "zone" : address['zone'],
          "country_id": address['country_id'],
          "customer_id": preferences.getInt(id).toString(),
          "address_id" : address['address_id']
      };
      print(addAddessToOrder+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          addAddessToOrder+"&api_token="+preferences.getString(api_token),
          body: addressToSend
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        
        final responseJson = json.decode(response.body);
print(responseJson.toString()+"hello");
         
        setState(() {
            isLoading = false;
           
          });
          addressToOrderDetail = addressToSend;
          addPaymentAddressToOrder(address);
         
        
       
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

addPaymentAddressToOrder(dynamic address) async 
{
   var preferences = await SharedPreferences.getInstance();
     try {
      setState(() {
        isLoading = true;
      });
      Map addressToSend = {
          "firstname": address['firstname'],
          "lastname": address['lastname'],
          "address_1": address['address_1'],
          "address_2": address['address_2'],
          "postcode" : address['postcode'],
          "city": address['city'],
          "zone_id": address['zone_id'],
          "zone" : address['zone'],
          "country_id": address['country_id'],
          "customer_id": preferences.getInt(id).toString()
      };
      print(addPaymentAddessToOrder+"&api_token="+preferences.getString(api_token));
      final response = await http.post(
          addPaymentAddessToOrder+"&api_token="+preferences.getString(api_token),
          body: addressToSend
      );
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        
         if(responseJson['status'])
        {
            print(responseJson);
            setState(() {
              isLoading = false;
              
            });
            addressToOrderDetail = addressToSend;
Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => OrderDetail()));
        
       
        }
        else
        {
          showToast("Something went wrong");
          setState(() {
            isLoading = false;
          });
          
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







class AddressCell extends StatelessWidget {

  dynamic address;
  Function deleteRequest;
  Function addAddress;
  String title;


  AddressCell(this.address, this.title, this.deleteRequest, this.addAddress);

  @override
  Widget build(BuildContext context) {




    void deleteDialog() async
    {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Delete this address?',
                style: TextStyle(
                    color: darkText,
                  fontWeight: FontWeight.bold
                ),),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes',
                  style: TextStyle(
                    color: darkText
                  ),),
                  onPressed: this.deleteRequest,
                ),
                FlatButton(
                  child: Text('No',
                    style: TextStyle(
                        color: primaryColor
                    ),),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),

              ],
            );
          }
      );

    }


    return GestureDetector(
      onTap: title == "Select Address" ? addAddress : null,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: primaryColor, size: 15,),
                        SizedBox(width: 10),
                        Text(address['postcode'],
                            style: TextStyle(
                              color: primaryColor,
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 6),
                    Text(address['firstname'] + ' ' + address['lastname'],
                        style: TextStyle(
                            color: darkText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),

                    SizedBox(height: 3),
                    Text("Address: "+address['address_1'],
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        )
                    ),

                    SizedBox(height: 3),
                    Text(address['city'],
                        style: TextStyle(
                            color: lightestText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                        )
                    ),

                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      onPressed: (){
                        deleteDialog();
                      },
                      icon:  Icon( Icons.delete, size: 20,),
                      color: lightGrey,
                    ),
                  )
                )
              ],
            )
          ),
        )
      ),
    );



  }




}

