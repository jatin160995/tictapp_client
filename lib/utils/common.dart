import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//FB2056

//const primaryColor = Color(0xFFED3134);
const primaryColor = Color(0xFF3aaa35);
const white = Color(0xffffffff);
const background = Color(0xFFf8f8f8);
//const accent = Color(0xFFED3134);
const darkText = Color(0xFF222222);
const lightText = Color(0xFF454545);
const lightestText = Color(0xFF656565);
const transparent = Color(0x00ffffff);
const transparentBlack = Color(0xa0000000);
const transparentBackground = Color(0x20000000);
const lightGrey = Color(0xa0d8d8d8);
const iconColor = Color(0xa0888888);
const transparentREd = Color(0x70df0000);
const backgroundGrey = Color(0xFF90a4ae);
const statusBarColor = Color(0xffd8d8d8);
const greenButton = Color(0xff3aaa35);
const lightGreen = Color(0xff7BC45D);
const lightestGreen = Color(0xffc5fcae);
const greenBackground = Color(0x80c5fcae);
const orange = Color(0xfffa7e37);
const blueColor = Colors.blue;
const dividerColor = Color(0xffeeeeee);



const auth = 'Bearer 64tdnqc6cuwr56a3yk2qlazwt1n8bmgf';
const contentType = 'application/json';
const domainURL = 'https://lanesopen.com/';
String storeUrl = domainURL+'index.php/rest/V1/mstore/categories';

// products
String categoriesURLPre =  domainURL+'index.php/rest/V1/mstore/products/?searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=';
String categoriesURLPost = '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1';

String categoriesURLPostProd = '&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[pageSize]=';
String urlPrefix = domainURL;

// get cartID
String createCartId = domainURL+'index.php/rest/V1/carts/mine';
//item to cart
String itemToCartURL(String qouteID)
{
  String url = domainURL+ 'index.php/rest/V1/carts/mine/items';
  return url;
}

// delete cart Item
String deleteCartItem(String itemId)
{
  String url = domainURL+ 'index.php/rest/V1/carts/mine/items/'+ itemId;
  //https://lanesopen.com/index.php/rest/V1/guest-carts/QibmjQIzGii6uRG98GANHtQanrOaPERU/items/11945
  return url;
}
// cart items
String cartItems = domainURL+'index.php/rest/V1/guest-carts/';
//login
String loginUrl = domainURL+'index.php/rest/V1/integration/customer/token';
String signUpUrl = domainURL+'index.php/rest/V1/customers';
String saveAddress = domainURL+ 'index.php/rest/V1/carts/mine/shipping-information';

String userInfo = domainURL+ 'index.php/rest/V1/customers/me';
String deleteAddress = domainURL+ 'index.php/rest/V1/addresses/';
String forgotPassword = domainURL+ 'rest/V1/customers/password';
String changePasswordURL = domainURL+ 'rest/V1/customers/me/password';
String sendDateTime = domainURL+ 'index.php/rest/V1/Iorderaddons/details/';
String clearCart = domainURL+ 'index.php/rest/V1/Iclearcart/details/';
String orders = domainURL+ 'index.php/rest/V1/Icustomerorder/details/';
String ordersDetail = domainURL+ 'index.php/rest/V1/Iorder/details/';
String createOrderURl = domainURL+ 'index.php/rest/V1/carts/mine/order';
String getCartValuesUrl = domainURL+ 'index.php/rest/V1/guest-carts/';
String cartTotals = domainURL+'index.php/rest/V1/carts/mine/totals';


List skuList = new List();
List imageList = new List();
List cartList = new List();


//Cart Contatnts
String cartId = '';
bool cartOnHold= false;
int itemToDelete= 0;
int cartCount =0;
bool gettingCartId = false;
int updatingItemId = 0;
bool addressAdded = false;
bool isAddressAdded = false;


// shared Prefrence
String user_token = 'user_token';
String is_logged_in = 'is_logged_in';
String username = 'username';
String password = 'password';
String savedEmail = 'savedEmail';
String firstname = 'firstname';
String lastname = 'lastname';
String savedtelephone = "savedtelephone";
String id = 'id';
String store_id = 'store_id';
String cart_id = 'cart_id';
String cart_count = 'cart_count';
dynamic userInfoObject = '';

String savedPostalCode = '';


String placeholderImage  = "assets/images/loading.gif";


dynamic addressToOrderDetail;

const double bottomTabHeight = 55;




const apiKey = "5JuJS3YZP3NOtHaRMQp3RO15Uqnkn5KJshPYsYEA4nu4PxJmQoVV4uhqtviS0kHH8WeXOqNWc3ZGKqTBrLsf7hOFlG40SW1DIKJTOo6sFOtwEqWHhwxBVAIaelJ0NK4ipIXVXIlWhnyf6fuwD2noYLCFUSTZT5Pvxu0oJ4ze2X2dsGjWkb5J742SR7XInr0DKM8Z4ZluqJhlGAbeOpcusDGqLf2J3FNhgwmWFtkFAcEqJXasD7OSrqXhXhORurnp";
const url_string = "http://wetesting.in/tictapp/";
const website_username = "tictapp";
const getStoresUrl = url_string + "index.php?route=api/myhome/stores";
const getCatUrl = url_string + "index.php?route=api/mycategory";
const getProductUrl = url_string + "index.php?route=api/myproducts";
const getProductPro = url_string + "index.php?route=api/myproducts/pro";
const homeUrl = url_string + "index.php?route=api/home";
const getAddressURl = url_string + "index.php?route=api/address";
const editProfileUrl = url_string + "index.php?route=api/mycustomer/edit";
const addAddressURl = url_string + "index.php?route=api/address/add";
const addAddessToOrder = url_string + "index.php?route=api/shipping/address";
const addPaymentAddessToOrder = url_string + "index.php?route=api/payment/address";
const getPaymentMethodUrl = url_string + "index.php?route=api/payment/methods";
const setPaymentMethodUrl = url_string + "index.php?route=api/payment/method";
const getShippingMethodUrl = url_string + "index.php?route=api/shipping/methods";
const setShippingMethodUrl = url_string + "index.php?route=api/shipping/method";
const setCustomerToSessionUrl = url_string + "index.php?route=api/customer";
const createOrderUrl = url_string + "index.php?route=api/order/add";
const getUserOrder = url_string + "index.php?route=api/order/mylist";
const getUserOrderDetail = url_string + "index.php?route=api/order/detail";
const searchUrl = url_string + "index.php?route=api/myproducts/search";
const changePasswordUrl1 = url_string+ "index.php?route=api/mycustomer/changepassword";
const getStoreByLocation = url_string+ "index.php?route=api/stores";
const getTimingSlots = url_string+ "index.php?route=api/cart/gettimeslot";
const applyCouponUrl = url_string+'index.php?route=api/cart/coupon';




String tandCLink = "http://wetesting.in/tictapp/index.php?route=information/information&information_id=5";
String privacyLink = "http://wetesting.in/tictapp/index.php?route=information/information&information_id=3";
String mobileNumber = "+9879879";

String currentStoreId = "0";


// shared preferences used
String api_token = 'api_token';
String savedCartList = 'api_token';



double selectedLat = 0.0;
  double selectedLng = 0.0;

void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

String inr = "\$";
List cartTemporary = new List(); 
String storeIdInCart = "0";
String openedStoreId = "";
String openedStoreName = "";


void saveCartToLocal(dynamic productData) async
  {
    if(storeIdInCart == "0" || cartTemporary.length == 0)
    {
      storeIdInCart = openedStoreId;
    }
    
    bool isAdded = false;
    for(var pro in cartTemporary)
    {
      if(pro['product_id'] == productData['product_id'])
      {
        pro['quantity'] = pro['quantity'] + 1;
        isAdded = true;
      }
    }
    if(!isAdded)
    {
      productData['quantity'] = 1;
      productData['storeName'] = openedStoreName;
      cartTemporary.add(productData);
    }
    
    
   /* var preferences = await SharedPreferences.getInstance();
    //preferences.clear();
    //return;
    List<String> cartList = preferences.getStringList(savedCartList);
    try{
      int length = cartList.length;
      if(cartList.contains(productData))
      {
        return;
      }
      //print(length);
    }
    catch(e){
      cartList = new List();
    }
    bool isAdded = false;
    
    
      productData['quantity'] = 1;
      cartList.add(json.encode(productData.toString()));
    
    preferences.setStringList(savedCartList, cartList);
    print(cartList.length);*/
  }

  extension HexColor on Color
  {
    static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  }