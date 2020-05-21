import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/post_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        switch(settings.name){
          case '/':
            return MaterialPageRoute(builder: (_){
              return HomePage();
            });
          case '/login':
            return MaterialPageRoute(builder: (_)=>Login());
          case '/post':{
            final args = Map.from(settings.arguments);
            return MaterialPageRoute(builder: (_)=>PostPage(id: args["id"]));
          }
          default:
            return MaterialPageRoute(builder: (_){
              return HomePage();
            });
        }
      },
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.redAccent,
      ),
    );
  }
}
