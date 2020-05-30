import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image/network.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';

import 'package:online_shopping_app/utils/ApiBaseHelper.dart';

class PostPage extends StatefulWidget {
  final String id;
  PostPage({this.id});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var title;
  var description;
  var price;
  var number;
  var createdAt;
  var owner;
  var isFetching = true;
  var imageLists = [];
  int _currentImage = 0;


  @override
  Widget build(BuildContext context) {
    if(isFetching)
      return Scaffold(
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    else
    return Scaffold(
      body: CustomScrollView(
        physics: ScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: imageLists.length>0?400:0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: imageLists.length>0?Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 1,
                        onPageChanged: (index, reason){
                          setState(() {
                            _currentImage = index;
                          });
                        },
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                      items: imageLists.map((e){
                        return Builder(
                          builder: (BuildContext context){
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image( image: NetworkImageWithRetry(
                                ApiBaseHelper().getBaseURL()+"img/post/"+e["filename"],
                              )),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      imageLists.map((e){
                        int index = imageLists.indexOf(e);
                        return Container(
                          width: 12,
                          height: 12,
                          margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImage == index? Color.fromRGBO(0, 0, 0, 0.9)
                                :Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                  )
                ],
              ):null,
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: new EdgeInsets.all(16.0),
            sliver: new SliverList(
              delegate: new SliverChildListDelegate([
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton.icon(onPressed: (){
                              //Add to Shopping Cart
                            }, icon: Icon(Icons.favorite), label: Text("Add to Favorite")),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton.icon(onPressed: (){
                              //Chat with Seller
                            }, icon: Icon(Icons.chat), label: Text("Send Messages")),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(description, style: TextStyle(
                fontSize: 20,
              ),),
            ),
          )
        ],
      ),
    );
  }

  void fetchImages() async{
    final response = (await ApiBaseHelper().get("img/postid/"+widget.id, null))["body"];
    setState(() {
      imageLists = response;
    });
  }

  void fetchData() async{
    final response = (await ApiBaseHelper().post("post?id="+widget.id))["body"];
    var postdata = response;
    setState(() {
      title = postdata["data"]["postTitle"];
      createdAt = postdata["data"]["postDate"];
      owner = postdata["data"]["ownerid"];
      price = postdata["data"]["price"];
      number = postdata["data"]["quantity"];
      description = postdata["data"]["postBody"];
      isFetching = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImages();
    fetchData();
  }
}