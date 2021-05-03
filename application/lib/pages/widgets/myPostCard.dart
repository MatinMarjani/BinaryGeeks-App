import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  String owner_id;
  String owner_email;
  String owner_profile_image;
  String id;
  String title;
  String author;
  String publisher;
  String price;
  String province;
  String city;
  String zone;
  String status;
  String description;
  bool is_active;
  String image; //url
  String categories;
  String created_at;

  bool _noImage = true;

  PostCard(
    this.owner_id,
    this.owner_email,
    this.owner_profile_image,
    this.id,
    this.title,
    this.author,
    this.publisher,
    this.price,
    this.province,
    this.city,
    this.zone,
    this.status,
    this.description,
    this.is_active,
    this.image, //url
    this.categories,
    this.created_at,
  );

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat("###,###");
    price = formatter.format(int.parse(price));
    if (image == null)
      _noImage = true;
    else {
      _noImage = false;
    }

    return GestureDetector(
        onTap: (){},
        child: Card(
          borderOnForeground: true,
          elevation: 1,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _noImage
                    ? Container(
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
                          image,
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
                          categories,
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
        ));
  }
}
