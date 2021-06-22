import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:application/pages/PostPage.dart';
import 'package:application/util/Post.dart';
import 'package:application/util/Utilities.dart';
import 'package:test/test.dart';

//ignore: must_be_immutable
class PostCard extends StatelessWidget {
  Post post;
  String price;
  bool _noImage = true;
  bool isExchange = false;
  bool isBuy = false;
  bool isDonation = false;
  bool isActive = false;

  PostCard(this.post);

  final _title = Key('_title');
  final _author = Key('_author');
  final _categories = Key('_categories');
  final _province = Key('_province');
  final _price = Key('_price');
  final _currency = Key('_currency');
  final _cardTap = Key('_cardTap');

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat('###,###');
    if (post.image == null)
      _noImage = true;
    else {
      _noImage = false;
    }

    if (post.isActive == null || !post.isActive)
      isActive = false;
    else
      isActive = true;

    if (post.status == "مبادله") {
      isExchange = true;
      isBuy = false;
      isDonation = false;
    } else if (post.status == "خرید") {
      isExchange = false;
      isBuy = true;
      isDonation = false;
    } else if ( post.status == "اهدا") {
      isExchange = false;
      isBuy = false;
      isDonation = true;
    } else {
      isExchange = false;
      isBuy = false;
      isDonation = false;
    }

    return GestureDetector(
        key: _cardTap,
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
            padding: EdgeInsets.all(3),
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
                          key: _title,
                          style: TextStyle(fontSize: 18.0, fontFamily: 'myfont'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                        child: Text(
                          post.author,
                          key: _author,
                          style: TextStyle(fontSize: 15.0, fontFamily: 'myfont'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 2.0),
                        child: Text(
                          post.categories,
                          key: _categories,
                          style: TextStyle(fontSize: 13.0, fontFamily: 'myfont'),
                        ),
                      ),
                    ],
                  ),
                ),
                isActive
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60), side: BorderSide(color: Colors.red))),
                          ),
                          child: Text(
                            "غیرفعال",
                            style: TextStyle(color: Colors.red, fontFamily: Utilities().myFont),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                      child: Text(
                        post.province,
                        key: _province,
                        style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
                      ),
                    ),
                  ],
                )
                    : isExchange
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60), side: BorderSide(color: Colors.orange))),
                                ),
                                child: Text(
                                  "مبادله",
                                  style: TextStyle(color: Colors.orange, fontFamily: Utilities().myFont),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                            child: Text(
                              post.province,
                              key: _province,
                              style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
                            ),
                          ),
                        ],
                      )
                    : isBuy
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60), side: BorderSide(color: Colors.teal))),
                          ),
                          child: Text(
                            "خرید",
                            style: TextStyle(color: Colors.teal, fontFamily: Utilities().myFont),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                      child: Text(
                        post.province,
                        key: _province,
                        style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
                      ),
                    ),
                  ],
                )
                    : isDonation
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white38),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60), side: BorderSide(color: Colors.cyanAccent))),
                          ),
                          child: Text(
                            "اهدا",
                            style: TextStyle(color: Colors.cyanAccent, fontFamily: Utilities().myFont),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                      child: Text(
                        post.province,
                        key: _province,
                        style: TextStyle(fontSize: 14.0, fontFamily: 'myfont'),
                      ),
                    ),
                  ],
                )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 2.0, 2.0, 0.0),
                            child: Text(
                              Utilities().replaceFarsiNumber(formatter.format(post.price)),
                              key: _price,
                              style: TextStyle(fontSize: 15.0, color: Colors.green, fontFamily: 'myfont'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 2.0, 2.0),
                            child: Text(
                              "تومان",
                              key: _currency,
                              style: TextStyle(fontSize: 13.0, color: Colors.green, fontFamily: 'myfont'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 5.0, 2.0, 2.0),
                            child: Text(
                              post.province,
                              key: _province,
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
