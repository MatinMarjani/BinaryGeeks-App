import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myPostCard.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  void initState() {
    super.initState();
    log("Dashboard init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(children: <Widget>[
          Posts(),
        ]),
      ),
      drawer: MyDrawer(),
    );
  }

  Container Posts() {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new PostCard("title", "author", "category", "price", "province",
              "description"),
          SizedBox(
            height: 20,
          ),
          new PostCard("1", "author", "category", "price", "province",
              "description"),
          SizedBox(
            height: 20,
          ),
          new PostCard("2", "author", "category", "price", "province",
              "description"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
