import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  String title;
  String author;
  String category;
  String price;
  String province;
  String description;
  String Image_url;

  bool _noImage = true;

  PostCard(this.title, this.author, this.category, this.price, this.province,
      this.description, this.Image_url);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat("###,###");
    price = formatter.format(int.parse(price));

    if( Image_url == null ) _noImage = true;
    else { _noImage = false; }


    return Card(
      borderOnForeground: true,
      elevation: 1,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _noImage ?
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15)),
              width: 100,
              height: 120,
              child: Icon(
                Icons.flip_camera_ios_outlined,
                color: Colors.grey[800],
              ),
            )
            : ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                Image_url,
                width: 100,
                height: 120,
                fit: BoxFit.fitHeight,
              ),
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
