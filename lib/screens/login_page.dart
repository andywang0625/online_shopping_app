import 'package:flutter/material.dart';
import '../components/appbar.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key:key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Your Account"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Email or Username',
              ),
              validator: (value){
                if(value.isEmpty){
                  return "Username cannot be empty";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RaisedButton(
              onPressed: (){
                if(_formKey.currentState.validate()){
                  print("Submitted!");
                }
              },
              child: Text("Login"),
            ),
          )
        ]
      ),
    );
  }
}
