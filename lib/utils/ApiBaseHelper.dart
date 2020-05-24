import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiBaseHelper{
  static final String _baseUrl = "http://192.168.123.9:8000/api/";

  static Future<String> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }

  static updateToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  static getBaseURL(){
    return _baseUrl;
  }

  Future<dynamic> get(String url, [String jsonBody]) async{
    try{
      final request = http.Request("GET", Uri.parse(_baseUrl+url));
      if(jsonBody!=null)
        request.body = jsonBody;
      final response = await request.send();
      return {
        'body': await response.stream.bytesToString(),
        'code': response.statusCode,
      };
    }catch(e){
      throw BadRequestException();
    }
  }

  Future<dynamic> post(String url, [String jsonBody]) async{
    try{
      final response =  await http.post(
        _baseUrl+url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonBody,
      );
      return {
        'body': response.body,
        'code': response.statusCode,
      };
    } catch(e){
      throw BadRequestException();
    }

  }

}

class AppException implements Exception{
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);

  String toString(){
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException{
  FetchDataException([String message]) : super(message, "Error During Communication");
}

class BadRequestException extends AppException{
  BadRequestException([message]): super(message, "Invalid Request:");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}