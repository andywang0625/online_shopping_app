import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/ApiBaseHelper.dart';
import 'package:flutter/services.dart';

class PostEditor extends StatefulWidget {
  final String postId;
  PostEditor({this.postId});
  @override
  _PostEditorState createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  bool isFetching = true;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  void fetchResult() async{
    final postInfo = await ApiBaseHelper().post("post?id="+widget.postId);
    setState(() {
      this._titleController.text = postInfo["body"]["data"]["postTitle"];
      this._priceController.text = postInfo["body"]["data"]["price"];
      this._quantityController.text = postInfo["body"]["data"]["quantity"];
      this._contentController.text = postInfo["body"]["data"]["postBody"];
      this.isFetching = false;
    });
    print(postInfo["body"]["data"]);
  }

  void saveChanges() async{
    final token = await ApiBaseHelper.getToken();
    final response = await ApiBaseHelper().post(
      'postEdit',
      jsonEncode({
        "title": _titleController.text,
        "id": widget.postId,
        "token":token,
        "quantity": _quantityController.text,
        "price": _priceController.text,
        "description": _contentController.text
      }),
    );
    if(response["code"]==202){
      final message = SnackBar(
        content: Text(response["body"]["data"]["result"]),
      );
      Scaffold.of(context).showSnackBar(message);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: this.isFetching?Center(child: CircularProgressIndicator()):Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Title",
              ),
              controller: this._titleController,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price",
                        prefix: Text("\$"),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp(r"[0-9]+(\.?[0-9]?[0-9]?)?$")),
                      ],
                      controller: this._priceController,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Number",
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: this._quantityController,
                    ),
                  ),
                ],
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
                controller: this._contentController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Save Changes", style: TextStyle(color: Colors.white),),
                      ),
                      color: Colors.indigo.shade700,
                      onPressed: (){
                        //Save Changes
                        saveChanges();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}