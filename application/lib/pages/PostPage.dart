import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';

import 'package:application/pages/widgets/myPostCard.dart';


import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';


class PostPage extends StatefulWidget {
  final Post post;
  const PostPage(this.post);
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  void initState() {
    super.initState();
    setState(() {
      MyAppBar.appBarTitle =
          Text("BookTrader", style: TextStyle(color: Colors.white));
      MyAppBar.actionIcon = Icon(Icons.search, color: Colors.white);
    });
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
        child: Text(widget.post.id.toString()),
      ),
      drawer: MyDrawer(),
    );
  }
}
