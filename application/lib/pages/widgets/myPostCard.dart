import 'dart:ui';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  String title;
  String author;
  String category;
  String price;
  String province;
  String description;

  String url =
      "https://www.kindpng.com/picc/m/73-738543_collection-of-free-books-drawing-easy-download-on.png";

  PostCard(
    this.title,
    this.author,
    this.category,
    this.price,
    this.province,
    this.description,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 15,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              child:  Image.network(
                url,
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(width: 20),
            Column(
              children: <Widget>[
                Text(title,
                style: ,),
                Text(author),
                Text(category),
                Text(price),
                Text(province),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
