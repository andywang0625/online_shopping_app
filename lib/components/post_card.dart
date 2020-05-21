import 'package:flutter/material.dart';

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
  });

  final String id;
  final Color cardColor;
  final String title;
  final String number;
  final String owner;
  final String price;
  final String description;
  final bool image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(
                child: image?Image.network("http://192.168.123.9:8000/api/img/post/cover/"+id):null,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
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
      ),
    );
  }
}
