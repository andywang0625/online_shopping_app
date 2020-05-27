import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping_app/utils/ApiBaseHelper.dart';
import 'dart:async';
import 'dart:convert';
import '../components/appbar.dart';
import '../components/post_card.dart';
import 'package:http/http.dart' as http;


class Post {
  final int id;
  final String title;
  final String description;
  final String price;
  final String number;
  final String createdAt;
  final String userid;
  final bool image;

  Post(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.number,
      this.createdAt,
      this.userid,
      this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      number: json['number'],
      createdAt: json['created_at'],
      userid: json['userid'],
      image: json['image'],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = List();
  bool isFetching = true;
  int page = 0;
  String keyword;
  ScrollController _scrollController = ScrollController();

  @override
    void initState() {
      super.initState();
      fetchResults();
      _scrollController.addListener(() {
        if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
          setState(() {
            page = page + 1;
            fetchResults();
          });
        }
      });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void fetchResults() async{
    final response = await ApiBaseHelper().post(
      "posts",
      jsonEncode({
        'page': page.toString(),
        'keyWord': keyword,
      }),
    );
    var postlist = response["body"] as List;
    setState(() {
      posts.addAll(postlist.map((e) => Post.fromJson(e)).toList());
      isFetching=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Online Shopping"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async{
                String query = await showSearch(context: context, delegate: SearchBarDelegate());
                setState(() {
                  keyword = query;
                  posts = [];
                  page = 0;
                });
                fetchResults();
              },
            ),
          ],
        ),
        drawer: OnlineShoppingAppBar(),
        body: Center(
          child: !isFetching?ListView(children: posts.map((e) => PostCard(
            id: e.id.toString(),
            title: e.title,
            price: e.price,
            number: e.number,
            owner: e.userid,
            description: e.description,
            image: e.image,
            )).toList(), controller: _scrollController,):CircularProgressIndicator(),
        )
    );
  }
}


class SearchBarDelegate extends SearchDelegate<String>{
  List<String> list = [];

  getHistory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list = prefs.getStringList("searchHistory");
  }

  saveHistory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("searchHistory", list);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: ()=>query="",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: ()=>close(context, null),
    );
  }

  @override
  void showResults(BuildContext context){
    if(query!=null&&query!=""){
      list.add(query);
      saveHistory();
    }
    close(context, query);
  }

  @override
  Widget buildResults(BuildContext context){
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getHistory();
    if(list==null)
      list = [];
    return list.length!=null?ListView(
      children: [
        for(String item in list)
          ListTile(
            title:Text(
              item,
            ),
            onTap: (){
              close(context, item);
            },
          ),
        FlatButton(
          child: Text("Clear History"),
          onPressed: (){
            list = [];
            saveHistory();
            close(context, "");
          },
        )
      ],
    ):Container();
  }
  
}