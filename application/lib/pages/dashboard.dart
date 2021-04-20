import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:application/pages/widgets/myDrawer.dart';
import 'package:application/pages/widgets/myAppBar.dart';
import 'package:application/pages/widgets/myPostCard.dart';

import 'package:application/util/app_url.dart';
import 'package:application/util/Post.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Post> myPost = [];

  void initState() {
    super.initState();
    log("Dashboard init");
    //getPosts();
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
          new PostCard(
              "1", "author", "category", "price", "province", "description"),
          SizedBox(
            height: 20,
          ),
          new PostCard(
              "2", "author", "category", "price", "province", "description"),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  getPosts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse = null;
    var response;

    var token = sharedPreferences.getString("token");
    var id = sharedPreferences.getInt("id").toString();
    var url = Uri.parse("??????");

    try {
      response =
          await http.get(url, headers: {'Authorization': 'Token $token'});
      if (response.statusCode == 200) {
        log('200');
        print(response.body);
        jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            //_isLoading = false;
          });
        }
      } else {
        log('!200');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

    response = await http.get(url);
    final extractedData = json.decode(response.body);
    List posts = extractedData['post'];
    for (var i in posts) {
      myPost.add(Post(
        i["id"],
        i["title"],
        i["author"],
        i["publisher"],
        i["price"],
        i["province"],
        i["city"],
        i["zone"],
        i["status"],
        i["description"],
        i["is_active"],
        i["image"],
        //url
        i["categories"],
        i["created_at"],
      ));
    }
  }
}
