import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Title",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Information",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
