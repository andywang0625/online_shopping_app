import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ApiBaseHelper{
  BaseOptions options = BaseOptions(
    baseUrl: "http://192.168.123.9:8000/api/",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  Dio dio;
  ApiBaseHelper(){
    this.dio = Dio(this.options);
    //this.dio.interceptors.add(LogInterceptor(responseBody: false));
  }

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

  String getBaseURL(){
    return dio.options.baseUrl;
  }

  Future<dynamic> get(String url, [String jsonBody]) async{
    try{
      Response response;
      if(jsonBody!=null)
        response = await dio.request(url, data: jsonDecode(jsonBody), options: Options(method: "GET"));
      else
        response = await dio.request(url, options: Options(method: "GET"));
      return {
        'body': response.data,
        'code': response.statusCode,
      };
    }on DioError catch(e){
      print(e);
      return {'code':e};
    }
  }

  Future<dynamic> post(String url, [String jsonBody]) async{
    try{
      Response response;
      if(jsonBody!=null)
         response = await dio.post(url, data: jsonDecode(jsonBody));
      else
        response = await dio.post(url);
      return {
        'body': response.data,
        'code': response.statusCode,
      };
    } on DioError catch(e){
      print(e);
      return {'code':e};
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