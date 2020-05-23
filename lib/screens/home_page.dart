import 'dart:io';

import 'package:flutter/material.dart';
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
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("asdf");
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void fetchResults() async{
    final response = await http.post(
        "http://192.168.123.9:8000/api/posts",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
            'page': page.toString()
        }),
    );
    if (response.statusCode == 200) {
      var postlist = json.decode(response.body) as List;
      setState(() {
        posts.addAll(postlist.map((e) => Post.fromJson(e)).toList());
        isFetching=false;
      });
    } else {
      throw Exception("Cannot fetch data from server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Online Shopping"),
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
