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

class UserPosts extends StatefulWidget {
  final userId;
  UserPosts({this.userId});
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  List<Post> posts = List();
  bool isFetching = true;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  void fetchResults() async{
    final response = await ApiBaseHelper().post(
      "posts",
      jsonEncode({
        'userId': widget.userId,
      }),
    );
    var postlist = response["body"] as List;
    setState(() {
      posts.addAll(postlist.map((e) => Post.fromJson(e)).toList());
      isFetching=false;
    });
  }

  void deletePost(String postId) async{
    final response = await ApiBaseHelper().post(
      "post/delete",
      jsonEncode({
        'id': postId,
        'token': await ApiBaseHelper.getToken()
      }),
    );
    setState(() {
      posts = [];
      isFetching = true;
    });
    this.fetchResults();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Posts"),
        ),
        drawer: OnlineShoppingAppBar(currentPath: ModalRoute.of(context).settings.name),
        body: Center(
          child: !isFetching?ListView(children: posts.map((e) => PostCard(
            id: e.id.toString(),
            title: e.title.trim(),
            price: e.price,
            number: e.number,
            owner: e.userid,
            description: e.description.trim(),
            image: e.image,
            type: "mine",
            delete: this.deletePost,
          )).toList()):CircularProgressIndicator(),
        )
    );
  }
}