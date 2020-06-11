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
                      ),
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
                      onPressed: (){},
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
