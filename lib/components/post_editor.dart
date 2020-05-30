import 'package:flutter/material.dart';
import '../utils/ApiBaseHelper.dart';

class PostEditor extends StatefulWidget {
  final String postId;
  PostEditor({this.postId});
  @override
  _PostEditorState createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  @override
  Widget build(BuildContext context) {
    print(widget.postId);
    return Container(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
            ),
          )
        ],
      ),
    );
  }
}
