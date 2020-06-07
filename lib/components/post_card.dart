import 'package:flutter/material.dart';
import '../screens/post_edit.dart';

class PostCard extends StatelessWidget {
  PostCard({
    this.id,
    this.title,
    this.description,
    this.image=false,
    this.number,
    this.owner,
    this.price,
    this.cardColor=Colors.white,
    this.type="",
    this.delete,
  });

  final String id;
  final Color cardColor;
  final String title;
  final String number;
  final String owner;
  final String price;
  final String description;
  final bool image;
  final String type;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: cardColor,
        child: InkWell(
          onTap: (){
            if(this.type=="")
              Navigator.pushNamed(context, "/post", arguments: {'id': id});
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  this.type=="mine"?Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ButtonBar(
                      buttonPadding: EdgeInsets.all(0.0),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: RaisedButton(
                            color: Colors.red.shade700,
                            child: Text("Delete"),
                            onPressed: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Alert"),
                                  content: Text("Are you sure you really want to delete this post?"),
                                  actions: [
                                    FlatButton(
                                      child: Text("No"),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Yes"),
                                      onPressed: (){
                                        this.delete(this.id);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                        RaisedButton(
                          color: Colors.indigo.shade700,
                          child: Text("Edit"),
                          onPressed: (){
                            Navigator.pushNamed(
                                context, "/edit", arguments: {'postId': this.id});
                          },
                        )
                      ],
                    ),
                  ):Container(),
                  Row(
                    children: [
                      image?Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              "http://192.168.123.9:8000/api/img/post/cover/"+id,
                            ),
                          ),
                        ),
                      ):Expanded(
                        flex: 1,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              color: Colors.indigo.shade50,
                              child: Center(child: Text(
                                title[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.indigo.shade800,
                                ),
                              )),
                            ),
                          ),
                        )
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(title, style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 100),
                                        child: Divider(
                                          color: Colors.indigo.shade50,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        description,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
