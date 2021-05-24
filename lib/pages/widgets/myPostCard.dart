import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:application/pages/PostPage.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/Utilities.dart';

//ignore: must_be_immutable
class PostCard extends StatelessWidget {
  Post post;
  String price;
  bool _noImage = true;
  bool isExchange = false;

  PostCard(this.post);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat('###,###');
    if (post.image == null)
      _noImage = true;
    else {
      _noImage = false;
    }

    if (post.status == "مبادله")
      isExchange = true;
    else
      isExchange = false;

    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(post)));
        },
        child: Card(
          borderOnForeground: true,
          elevation: 1,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          color: Colors.white70,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _noImage
                    ? Container(
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
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
                          post.image,
                          loadingBuilder: (context, child, progress) {
                            return progress == null ? child : LinearProgressIndicator();
                          },
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
                          post.title,
                          style: TextStyle(fontSize: 18.0, fontFamily: 'myfont'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                        child: Text(
                          post.author,
                          style: TextStyle(fontSize: 15.0, fontFamily: 'myfont'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                        child: Text(
                          post.categories,
                          style: TextStyle(fontSize: 13.0, fontFamily: 'myfont'),
                        ),
                      ),
                    ],
                  ),
                ),
                isExchange
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60), side: BorderSide(color: Colors.red))),
                                ),
                                child: Text(
                                  "مبادله",
                                  style: TextStyle(color: Colors.white, fontFamily: Utilities().myFont),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                            child: Text(
                              post.province,
                              style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 0.0),
                            child: Text(
                              Utilities().replaceFarsiNumber(formatter.format(post.price)),
                              style: TextStyle(fontSize: 15.0, color: Colors.green, fontFamily: 'myfont'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 2.0, 2.0),
                            child: Text(
                              "تومان",
                              style: TextStyle(fontSize: 13.0, color: Colors.green, fontFamily: 'myfont'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                            child: Text(
                              post.province,
                              style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
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
