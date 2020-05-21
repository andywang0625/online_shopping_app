import 'package:flutter/material.dart';
import '../screens/login_page.dart';


class OnlineShoppingAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: new Text('Kanade'),
            accountEmail: new Text("admin@uotca.com"),
            currentAccountPicture: Icon(Icons.account_circle, size: 100, color: Colors.white,),
          ),
          ListTile(
            title: Text("Login"),
            onTap: (){
              Navigator.pushNamed(context, "/login");
            },
          )
        ],
      ),
    );
  }
}
