import 'package:flutter/material.dart';
import '../components/appbar.dart';
import '../components/post_editor.dart';

class PostEdit extends StatefulWidget {
  @override
  final String postId;
  PostEdit({this.postId});
  _PostEditState createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing"),
      ),
      drawer: OnlineShoppingAppBar(),
      body: PostEdit(postId: widget.postId),
    );
  }
}
