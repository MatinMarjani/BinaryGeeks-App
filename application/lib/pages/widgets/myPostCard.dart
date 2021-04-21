import 'dart:ui';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  String title;
  String author;
  String category;
  String price;
  String province;
  String description;

  String url = "https://wallpaperaccess.com/full/832966.jpg";

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
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 120,
                  // color: Colors.blue,
                  child: Image.network(
                    url,
                    width: 100,
                    height: 120,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                    child: Text(
                      author,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                  child: Text(
                    price,
                    style: TextStyle(fontSize: 15.0, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                  child: Text(
                    province,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
