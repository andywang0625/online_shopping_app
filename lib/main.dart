import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/login": (context) => Login(),
      },
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.redAccent,
      ),
    );
  }
}
