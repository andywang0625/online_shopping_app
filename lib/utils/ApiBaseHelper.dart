import 'dart:io';
import 'package:http/http.dart' as http;

class ApiBaseHelper{
  final String _baseUrl = "http://192.168.123.9:8000/api/";

  Future<dynamic> get(String url, String jsonBody) async{
    final request = http.Request("GET", Uri.parse(_baseUrl+url));
    request.body = jsonBody;
    final response = await request.send();
    return response.stream.bytesToString();
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