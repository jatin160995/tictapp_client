import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:tictapp/model/CustomException.dart';
import 'package:tictapp/utils/common.dart';

class ApiProvider {
  final String _baseUrl = url_string+"index.php?route=api/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> post(String url, Map bodyToSend) async {
    print(_baseUrl + url);
    print(bodyToSend);
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, body:bodyToSend);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postJsonToServer(String url, dynamic bodyToSend) async {
    print(_baseUrl + url);
    print(bodyToSend);
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, 
      headers: {
          HttpHeaders.contentTypeHeader: contentType},
          body: bodyToSend
          );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        
        //print(responseJson);
        return responseJson;
      case 400:
        showToast("Bad Request Exception");
        throw BadRequestException(response.body.toString());
        
      case 401:

      case 403:
         showToast("Unauthorised Exception");
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        showToast("Fetch Data Exception");
        throw FetchDataException(
          
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}