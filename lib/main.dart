import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/post_page.dart';
import 'screens/post_edit.dart';
import 'screens/user_posts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      onGenerateRoute: (settings) {
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
          case '/edit':{
            final args = Map.from(settings.arguments);
            return MaterialPageRoute(builder: (_)=>PostEdit(postId:args["postId"]));
          }
          case '/myposts':{
              final args = Map.from(settings.arguments);
              return MaterialPageRoute(builder: (_)=>UserPosts(userId: args["userId"]), settings: RouteSettings(name: "/myposts"));
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
