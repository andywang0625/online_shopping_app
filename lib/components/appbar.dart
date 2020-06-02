import 'dart:convert';
import 'dart:io';
import '../utils/ApiBaseHelper.dart';
import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String email;

  User({this.id, this.name, this.email});
}

Future<User> getUser() async {
  final token = await ApiBaseHelper.getToken();
  if(token!=null){
    final response = (await ApiBaseHelper().post("verify_login", jsonEncode({
      "token": token,
    })))["body"];
    if(response["status"])
      return User(
        id: response["id"],
        name: response["name"],
        email: response["email"],
      );
  }
  ApiBaseHelper.removeToken();
  return User();
}

class OnlineShoppingAppBar extends StatefulWidget {
  final currentPath;
  OnlineShoppingAppBar({this.currentPath = "/"});
  @override
  _OnlineShoppingAppBarState createState() => _OnlineShoppingAppBarState();
}

class _OnlineShoppingAppBarState extends State<OnlineShoppingAppBar> {
  Future<User> futureUser;
  var isFetching = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    futureUser = getUser().then((data) {
      setState(() {
        isFetching = false;
      });
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (isFetching) return Container();
          if (snapshot.hasData) {
            if (snapshot.data.name != null)
              return (Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: new Text(snapshot.data.name),
                      accountEmail: new Text(snapshot.data.email),
                      currentAccountPicture: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    ListTile(
                      title: Text("Logout"),
                      onTap: () {
                        ApiBaseHelper.removeToken();
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text("My Posts"),
                      onTap: (){
                        if(widget.currentPath!="/myposts"){
                          Navigator.pushNamed(
                              context, "/myposts", arguments: {'userId': snapshot.data.id});
                        }else
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text("test"),
                      onTap: (){

                      },
                    )
                  ],
                ),
              ));
            else
              return (Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        color: Colors.indigo,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome!",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.indigo.shade200,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Login"),
                      onTap: () {
                        Navigator.pushNamed(context, "/login").then((data) {
                          setState(() {
                            futureUser = getUser();
                          });
                        });
                      },
                    )
                  ],
                ),
              ));
          } else {
            return (Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      color: Colors.indigo,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome!",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.indigo.shade200,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Login"),
                    onTap: () {
                      Navigator.pushNamed(context, "/login").then((data) {
                        setState(() {
                          futureUser = getUser();
                        });
                      });
                    },
                  )
                ],
              ),
            ));
          }
        });
  }
}
