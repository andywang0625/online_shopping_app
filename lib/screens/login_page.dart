import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../components/appbar.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key key}) : super(key:key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  onLogin() async{
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      "http://192.168.123.9:8000/api/login_request",
      headers: {
        HttpHeaders.contentTypeHeader:"application/json",
      },
      body: jsonEncode({
        'name': username,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      var token = json.decode(response.body)["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);

      Navigator.of(context).pop();
    }
    else{
      final message = SnackBar(
        content: Text(json.decode(response.body)["error"]),
      );
      _scaffoldKey.currentState.showSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login With Your Account"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email or Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                      controller: _usernameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value){
                        if(value.isEmpty){
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                      controller: _passwordController,
                    )
                  ]
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          onLogin();
                        }
                      },
                      child: Text("Login"),
                    ),
                  ),
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}
